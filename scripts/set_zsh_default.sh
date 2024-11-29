#!/bin/bash

function check_zsh() {
  if ! command -v zsh > /dev/null 2>&1; then
    echo "Error: Zsh is not installed. Please install Zsh first."
    exit 1
  fi
}

function make_default_shell() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"
  else
    echo "Zsh is already the default shell."
  fi
}


check_zsh
make_default_shell
echo "Restarting the shell..."
exec zsh
