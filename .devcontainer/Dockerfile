# ---------- Stage 1/2: Base builder ----------
FROM alpine:3.23.3 AS base-builder

# OS packages
RUN apk update \
    && apk add --no-cache \
    bash \
    ca-certificates \
    coreutils \
    curl

# Taskfile (pinned). Pure-Go static binary — same artifact runs on Alpine and Ubuntu.
ARG TASK_VERSION=v3.51.1
RUN curl -sSL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin "${TASK_VERSION}"


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
    cabal-install \
    ghc \
    haskell-stack \
    hlint \
    ormolu \
    \
    # ----------.github/workflows C/C++ Development ----------
    clang-format \
    cmake \
    g++ \
    gcc \
    gdb \
    make \
    \
    # ---------- Python Formatters/Linters ----------
    black \
    \
    # ---------- YAML Linter ----------
    yamllint \
    \
    # ---------- Shell Linter ----------
    shellcheck \
    \
    # ---------- R ----------
    r-base \
    r-base-dev \
    r-cran-lintr \
    \
    # ---------- Container & Network Tools ----------
    bind9-dnsutils \
    && rm -rf /var/lib/apt/lists/*

# Ruff is not packaged by Ubuntu. Installed system-wide for task fmt/lint; course
# venvs pin their own copy.
RUN pip3 install --no-cache-dir --break-system-packages ruff

# R language server (VS Code R extension) and formatter are not in apt. Builds
# from source, which is why r-base-dev is installed above.
RUN Rscript -e 'install.packages(c("languageserver", "styler"), repos = "https://cloud.r-project.org")'

# PATH
ENV PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# OSLO TZ
ENV TZ="Europe/Helsinki"
