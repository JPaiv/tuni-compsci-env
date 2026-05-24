# ---------- Stage 1/2: Base builder ----------
FROM alpine:3.23.3 AS base-builder

# OS packages
RUN apk update \
    && apk add --no-cache \
    bash=5.3.3-r1 \
    ca-certificates=20251003-r0 \
    coreutils=9.8-r1 \
    curl=8.17.0-r1

# Taskfile
# Pure-Go static binary
RUN curl -sSL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin


# ---------- Stage 2/2: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Binaries
COPY --chmod=765 --from=base-builder /usr/local/bin /usr/local/bin

# Devcontainer post-start script
COPY --chmod=755 post-start.sh /usr/local/bin/post-start

# OS PACKAGE DEPENDENCIES
# Common utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv  \
    \
    # ---------- Shell Enhancements ----------
    bash-completion \
    bat \
    ripgrep \
    \
    # ---------- Haskell Development ----------
    ghc \
    cabal-install \
    haskell-stack \
    \
    # ----------.github/workflows C/C++ Development ----------
    gcc \
    g++ \
    gdb \
    make \
    cmake \
    \
    # ---------- Container & Network Tools ----------
    bind9-dnsutils \
    && rm -rf /var/lib/apt/lists/*

# PATH
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# OSLO TZ
ENV TZ="Europe/Helsinki"