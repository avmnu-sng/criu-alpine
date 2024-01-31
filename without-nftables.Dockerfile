ARG PLATFORM
ARG BASE

FROM --platform=$PLATFORM $BASE

ARG CRIU_VERSION

RUN apk --update --no-cache add \
    asciidoc \
    bash \
    build-base \
    coreutils \
    procps \
    gcc \
    git \
    libaio-dev \
    libcap-dev \
    libnet-dev \
    libnl3-dev \
    pkgconfig \
    protobuf-c-dev \
    protobuf-dev \
    py3-pip \
    py3-protobuf \
    py3-yaml \
    python3 \
    libcap-utils \
    libdrm-dev \
    util-linux \
    xmlto

RUN wget "http://github.com/checkpoint-restore/criu/archive/v${CRIU_VERSION}/criu-${CRIU_VERSION}.tar.gz" && \
    tar -xzf "criu-${CRIU_VERSION}.tar.gz" && \
    cd "criu-${CRIU_VERSION}" && \
    make -j $(nproc) CONFIG_AMDGPU=n PREFIX=/usr DESTDIR=/criu LIBDIR=/usr/lib LD=gcc install && \
    rm -f /criu/usr/lib/*.a && \
    rm -rf /criu/usr/lib/python3* && \
    rm -rf /criu/usr/libexec/compel/*.a && \
    rm -f /criu/usr/libexec/criu/scripts/systemd-autofs-restart.sh
