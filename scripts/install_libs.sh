#!/bin/bash

# Default values
GO_VERSION=${1:-"1.23.3"}
SCRIPT_DIR=$(dirname "$(realpath "$0")")
PARENT_DIR=$(dirname "$SCRIPT_DIR")
CUSTOM_ZSHRC_PATH="$PARENT_DIR/.zshrc"
ZSHRC_PATH="${HOME}/.zshrc"

function check_git_installed() {
  if ! command -v git > /dev/null 2>&1; then
    echo "Git is not installed."
  fi
}

function install_dot_file_zshrc() {
  cp "$CUSTOM_ZSHRC_PATH" "$ZSHRC_PATH"
}

function install_base_libs_apt() {
  sudo apt update -y
  sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    libnss3-dev \
    libncurses-dev \
    libgdbm-dev \
    libgdbm-compat-dev \
    uuid-dev \
    tk-dev \
    xz-utils \
    gdb \
    cmake \
    curl \
    liblzma-dev \
    gcc \ 
    wget \
    curl \
    pipx \
    jq \
    unzip \
    zsh
}

function install_omzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    --keep-zshrc \
    --unattended
}

function install_pyenv() {
  curl https://pyenv.run | bash
}

function install_go() {
  echo "Installing Go version: $GO_VERSION"
  wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
  rm go${GO_VERSION}.linux-amd64.tar.gz

  if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
  fi
}

install_base_libs_apt
install_omzsh
install_dot_file_zshrc
install_pyenv
install_go
