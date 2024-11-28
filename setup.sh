#!/bin/bash
# ```
# bash setup.sh 1.23.3
# ```

GO_VERSION="${1:"1.23.3"}"

SCRIPT_DIR=$(dirname "$(realpath "$0")")
ZSHRC_PATH="$SCRIPT_DIR/.zshrc"

function check_zshrc() {
  if [ ! -f "${ZSHRC_PATH}" ]; then
    echo "$ZSHRC_PATH should contain a .zshrc config."
    echo "git clone git@github.com:ltbringer/reboot.git"
  fi
}

function setup_zshrc() {
  cp $ZSHRC_PATH ~/.zshrc
  source ~/.zshrc
}


function install_base_libs_apt() {
  sudo apt update -y
  # Update the local package database.
  # Fetch latest versions of available packages from the repositories listed in /etc/apt/sources.list.

  sudo apt install -y git gcc wget curl zsh pipx jq unzip
}

function install_omzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function install_pyenv() {
  # .zshrc should have an initializer for this.
  # So to setup pyenv path and initializing pyenv
  # restarting the shell program should be enough.
  curl https://pyenv.run | bash
}

function install_go() {
  wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
  rm go${GO_VERSION}.linux-amd64.tar.gz
  # Add Go to the shell path
  if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
  fi
}


check_zshrc
install_base_libs_apt
install_omzsh
# bc omzsh overwrites older zshrc if present.
# so we will cp the desired config after installing it.
setup_zshrc
# bw_get_ssh_keys is defined in zshrc
bw_get_ssh_keys
install_pyenv
install_go

# Restart to source env vars and any other setup.
exec $(SHELL)
