# 🖥️ Tampere University Computer Science Devcontainer

This repository provides a ready-to-use development environment for Tuni Computer Science course work. It uses Devcontainer and Docker.

All tools are preinstalled

## 🚀 Features

Preconfigured VS Code Devcontainer

Includes:

- Common tools (curl, ripgrep, bat, GitHub CLI)
- Formatters & linters wired to VS Code (Prettier, Black, clang-format, shfmt, markdownlint)
- [Task](https://taskfile.dev) — task runner with a course-aware C/C++ build target
- Ubuntu 24 devcontainer

Programming languages:

- C / C++ (gcc, g++, gdb, make, cmake)
- Haskell (ghc, cabal, stack)
- Python 3
- JavaScript / TypeScript

## 📦 Requirements

Before starting, install:

Docker Desktop

- [Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

[Visual Studio Code](https://code.visualstudio.com/download)

## 🛠️ Git Setup

Github has good [docs](https://docs.github.com/en/get-started/git-basics/set-up-git)

Windows users should try [Github Desktop](https://desktop.github.com/download/)

## 🛠️ Setup Instructions

1. Clone the repository

2. Open the project folder in VS Code.

3. When prompted, select “Reopen in Container”.

4. VS Code and Docker will handle the rest

## ⚡ Building C / C++ with Task

The repo ships a `Taskfile.yml`. The `build` target picks the compiler from the course in the path:

| Course                 | Compiler | Standard   |
| ---------------------- | -------- | ---------- |
| cs.120                 | gcc      | `-std=c11` |
| cs.110, cs.111, cs.115 | g++      | `-std=c++17` |

```bash
task --list                                                # show all tasks
task build     -- src/courses/cs.120/unsigned_interval.c   # auto: gcc
task build     -- src/courses/cs.110/.../foo.cpp           # auto: g++
task build:c   -- path/to/file.c                           # force gcc
task build:cpp -- path/to/file.cpp                         # force g++
```

The output binary is placed next to the source file with the extension stripped.

## 📝 Editor configs

Formatter and linter configs live at the repo root and are picked up automatically by VS Code:

- `.editorconfig` — indent, EOL, trailing whitespace
- `.clang-format` — C/C++ (LLVM base, Allman braces, 100 col)
- `pyproject.toml` — Black + Ruff
- `.prettierrc.json` — Prettier (JS/TS/JSON/MD/YAML)
- `.markdownlint.json` — Markdown lint
