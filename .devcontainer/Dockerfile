# ---------- Stage 1/4: Base builder ----------
FROM alpine:3.23.3 AS base-builder

# OS packages
RUN apk update \
    && apk add --no-cache \
    bash=5.3.3-r1 \
    ca-certificates=20251003-r0 \
    coreutils=9.8-r1 \
    curl=8.17.0-r1


# ---------- Stage 4/4: Runtime devcontainer ----------
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
    bash-completion=1:2.11-8 \
    bat=0.24.0-1build1 \
    ripgrep=14.1.0-1 \
    \
    # ---------- Container & Network Tools ----------
    bind9-dnsutils=1:9.18.39-0ubuntu0.24.04.2 \
    && rm -rf /var/lib/apt/lists/*

# PATH
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# OSLO TZ
ENV TZ="Europe/Helsibki"