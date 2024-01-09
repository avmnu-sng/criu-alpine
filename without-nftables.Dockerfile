ARG PLATFORM
ARG BASE

FROM --platform=$PLATFORM $BASE

ARG CRIU_VERSION

RUN apk --update --no-cache add \
    bash \
    build-base \
    coreutils \
    procps \
    gcc \
    git \
    gnutls-dev \
    libaio-dev \
    libcap-dev \
    libnet-dev \
    libnl3-dev \
    pkgconfig \
    protobuf-c-dev \
    protobuf-dev \
    py3-pip \
    py3-protobuf \
    python3 \
    libcap-utils \
    libdrm-dev \
    util-linux

WORKDIR /tmp

RUN wget "http://github.com/checkpoint-restore/criu/archive/v${CRIU_VERSION}/criu-${CRIU_VERSION}.tar.gz" && \
    tar -xzf "criu-${CRIU_VERSION}.tar.gz" && \
    cd "criu-${CRIU_VERSION}" && \
    make -j $(nproc) install-criu

COPY multi-stage-setup.py multi-stage-setup.py

RUN chmod +x multi-stage-setup.py && \
    ./multi-stage-setup.py
