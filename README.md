# 🖥️ Tampere University Computer Science Devcontainer

This repository provides a ready-to-use development environment for Tuni Computer Science course work. It uses Devcontainer and Docker.

All tools are preinstalled

## 🚀 Features

Preconfigured VS Code Devcontainer (.devcontainer/devcontainer.json)

Includes common CS tools:

Python 3 + pip

Git + curl + build tools

Node.js (optional)

C++ compiler and debugger

Extendable via Dockerfile

## 📦 Requirements

Before starting, install:

Docker Desktop
    [Linux](https://docs.docker.com/desktop/setup/install/linux/)
    [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
    [Windows](https://docs.docker.com/desktop/setup/install/windows-install/)

[Visual Studio Code](https://code.visualstudio.com/download)

## 🛠️ Setup Instructions

1. Clone the repository

2. Open in VS Code

Open the project folder in VS Code.
When prompted, select “Reopen in Container”.
VS Code will build the container using the included Dockerfile.

## 🧑‍💻 Usage

Inside the devcontainer, you can:

# Python
python3 main.py

# C++
g++ hello.cpp -o hello && ./hello

# Node.js
node index.js
