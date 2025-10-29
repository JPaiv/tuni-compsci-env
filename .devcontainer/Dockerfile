# ---------- Stage 1/3: Base builder ----------
FROM alpine:3.22.1 AS base-builder

# OS packages
RUN apk update \
    && apk add --no-cache \
    bash \
    curl \
    build-base \
    clang \
    clang-dev \
    clang-extra-tools \
    cmake \
    extra-cmake-modules \
    llvm \
    llvm-dev

# ---------- Stage 2/3: Node builder ----------
FROM node:24.5.0 AS node-builder

# Typescript
# TSX§§
# Tools
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    tsx \
    eslint

# ---------- Stage 3/3: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Depencies
COPY --chmod=765 --from=base-builder /usr/local/bin /usr/local/bin
COPY --chmod=765 --from=base-builder /usr/bin/clang /usr/bin/clang
COPY --chmod=765 --from=base-builder /usr/bin/clang++ /usr/bin/clang++
COPY --chmod=765 --from=base-builder /usr/bin/cmake /usr/bin/cmake
COPY --chmod=765 --from=base-builder /usr/bin/llvm-config /usr/bin/llvm-config
COPY --chmod=765 --from=base-builder /usr/bin/make /usr/bin/make

# Node
COPY --chmod=765 --from=node-builder /usr/local/bin /usr/local/bin
COPY --chmod=765 --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Devcontainer post start script
COPY --chmod=765 post-start.sh /usr/local/bin/post-start

ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local"

# DEPENCIES
# Python3
# R
# Common utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv  \
    r-base \
    apache2-utils \
    bash-completion \
    eza \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Helsinki time zone
ENV TZ="Europe/Helsinki"

# Default User
USER vscode
