# Reboot

This repo is a way to recreate my home machine's environment anywhere.

## Pre Requisite

```
apt install -y git build-essential
```

## Usage

```
make BW_SECRETS_PATH=/path/to/api_key.json.gpg BW_PWD_PATH=/path/to/password.gpg
make BW_SECRETS_PATH=/path/to/api_key.json.gpg BW_PWD_PATH=/path/to/password.gpg GO_VERSION=1.23.3
```

## Breakdown

1. Installs libraries I commonly use. One of which is the `zsh` shell.
2. [oh-my-zsh](https://github.com/ohmyzsh/) - A plugin I have used for years.
3. Download my secrets from [BitWarden](https://bitwarden.com/).
