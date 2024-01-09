## CRIU Alpine

Use this dockerimage to add [criu](https://github.com/checkpoint-restore/criu) as
part of multi-stage build. To use in multistage build copy all the contents from
the `/criu` directory to `/` (root) directory.

Ensure to use same alpine image for the final stage, i.e., if we use `alpine:3.18.5`
with digest `sha256:d695c3de6fcd8cfe3a6222b0358425d40adfd129a8a47c3416faff1a8aece389`,
then:

```dockerfile
FROM --platform=amd64 alpine:3.18.5@sha256:d695c3de6fcd8cfe3a6222b0358425d40adfd129a8a47c3416faff1a8aece389

COPY --from=criu-3.19-with-nftables:alpine-3.18.5 /criu/ /
```
