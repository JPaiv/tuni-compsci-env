# ---------- Stage 1/3: Javascript builder ----------
FROM node:24.5.0 AS node-builder

RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

# ---------- Stage 2/3: Golang builder ----------
FROM golang:1.25 AS go-builder

# Verify Go
RUN echo "Golang Version:" && go version

# ---------- Stage 3/3: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Node
COPY --chmod=765 --from=node-builder /usr/local/bin /usr/local/bin

# NPM
COPY --chmod=765 --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Golang
COPY --chmod=765 --from=go-builder /usr/local/go /usr/local/go

# Python formatter requirements
COPY --chmod=765 requirements.txt ./

# Devcontainer post start script
COPY post-start.sh /usr/local/bin/post-start

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    clang \
    cmake \
    gdb

ENV PATH="/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin"

# Helsinki time zone
ENV TZ="Europe/Helsinki"
