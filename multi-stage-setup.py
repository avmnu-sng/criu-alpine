#!/usr/bin/env python3

from pathlib import Path
from shutil import copy2
from subprocess import run
from sys import exit

CRIU_ROOT = '/criu'
CRIU_BIN_DIR = f'{CRIU_ROOT}/usr/bin'


def setup_criu_root():
  Path(CRIU_ROOT).mkdir(parents=True, exist_ok=False)
  Path(CRIU_BIN_DIR).mkdir(parents=True, exist_ok=False)

  if not run(f'cp `which criu` {CRIU_BIN_DIR}', shell=True).returncode == 0:
    exit(1)


def copy_dep(dep):
  dep_dir = str(Path(CRIU_ROOT).joinpath(Path(dep).parent.relative_to('/')))
  Path(dep_dir).mkdir(parents=True, exist_ok=True)

  copy2(dep, dep_dir)


if __name__ == '__main__':
  setup_criu_root()

  res = run('ldd `which criu`', capture_output=True, shell=True)
  if not res.returncode == 0:
    exit(1)

  deps = res.stdout.decode().strip().split("\n")

  for dep in deps:
    parts = dep.strip().split(' => ')
    if len(parts) not in (1, 2):
      exit(1)

    part1 = None
    part2 = None

    if len(parts) == 1:
      part1 = parts[0].split(' (0x')[0]
      part2 = part1
    else:
      part2 = parts[1].split(' (0x')[0]
      part1 = str(Path(part2).parent.joinpath(parts[0]))

    if not part1 or not part2:
      exit(1)

    copy_dep(part1)

    if part1 != part2:
      copy_dep(part2)
