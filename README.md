# Reboot

This repo is a way to recreate my home machine's environment anywhere.

## Pre Requisites

1. You need the following dependencies to get started.
    ```
    apt install -y git build-essential gnupg
    ```
2. This repo requires attachments on Bitwarden which is a premium (~$10/year) feature.
3. Create a folder/directory and attach your secrets. At least ssh and gpg keys.
4. Create API keys for bitwarden and save them as json on your disk. Encrypt this using gpg. These can always be rotated and created again.
5. Create a file that contains your master password. Encrypt this using gpg.

If you are on a clean install, you can download your private key from Bitwarden and run:
```
gpg --import /path/to/private/key
```
This should be the same key used for encrypting Bitwarden API keys and master password.

## Usage

`BW_SECRETS_PATH`: Local path to encrypted Bitwarden API keys (as json) are stored.
`BW_SECRETS_FOLDER`: Bitwarden folder (remote) where secrets are stored.
`BW_PWD_PATH`: Local path to encrypted Bitwarden master password.

```
make BW_SECRETS_PATH=/path/to/api_key.json.gpg BW_PWD_PATH=/path/to/password.gpg BW_SECRETS_FOLDER=ssh
```

You can choose to install a specific version of golang by providing `GO_VERSION`.
```
make BW_SECRETS_PATH=/path/to/api_key.json.gpg BW_PWD_PATH=/path/to/password.gpg BW_SECRETS_FOLDER=ssh GO_VERSION=1.23.3
```

## Breakdown

1. Installs libraries I commonly use. One of which is the `zsh` shell.
2. [oh-my-zsh](https://github.com/ohmyzsh/) - A plugin I have used for years.
3. Download my secrets from [BitWarden](https://bitwarden.com/).
