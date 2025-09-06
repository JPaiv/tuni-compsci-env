# ---------- Stage 1/3: Javascript builder ----------
FROM node:24.5.0 AS node-builder

# Verify Javascript
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

# ---------- Stage 2/3: Go builder ----------
FROM golang:1.25 AS go-builder

# Verify Go
RUN echo "Golang Version:" && go version

# ---------- Stage 3/3: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Node
COPY --chmod=765 --from=node-builder /usr/local/bin /usr/local/bin
COPY --chmod=765 --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Go
COPY --chmod=765 --from=go-builder /usr/local/go /usr/local/go

# Devcontainer post start script
COPY --chmod=765 post-start.sh /usr/local/bin/post-start

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:${PATH}"

# DEPENCIES
# Python3
# C++
# Common utils
RUN apt-get update \
    && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    clang \
    cmake \
    gdb \
    apache2-utils

# Helsinki time zone
ENV TZ="Europe/Helsinki"
