# ---------- Stage 1/4: Javascript builder ----------
FROM node:24.5.0 AS node-builder

# Typescript
# TSX
# Zig
# Tools
RUN npm install -g \
    typescript \
    typescript ts-node \
    @types/node \
    tsx  \
    @ziglang/cli \
    eslint

# ---------- Stage 2/3: Go builder ----------
FROM golang:1.25 AS go-builder

RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# ---------- Stage 3/3: Runtime devcontainer ----------
FROM mcr.microsoft.com/devcontainers/base:ubuntu AS runtime

# Node
COPY --chmod=765 --from=node-builder /usr/local/bin /usr/local/bin
COPY --chmod=765 --from=node-builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Go
COPY --chmod=765 --from=go-builder /usr/local/go /usr/local/go
COPY --chmod=765 --from=go-builder /go/bin /go/bin

# Devcontainer post start script
COPY --chmod=765 post-start.sh /usr/local/bin/post-start

ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/go/bin:/usr/local:/usr/share/dotnet:/usr/local/cargo/bin:/root/.cargo/bin"

# DEPENCIES
# Python3
# C++
# Haskell
# Common utils
# R
# Rust
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv  \
    build-essential \
    cabal-install \
    ghc \
    haskell-stack \
    apache2-utils \
    bash-completion \
    eza \
    ripgrep \
    r-base \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

# Helsinki time zone
ENV TZ="Europe/Helsinki"

USER vscode