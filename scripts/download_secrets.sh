#!/bin/bash

BW_SECRETS_PATH=$1
BW_PWD=$2
BW_DOWNLOAD_URL="https://vault.bitwarden.com/download/?app=cli&platform=linux"
INSTALL_DIR="$HOME/packages"  # Adjust the installation directory if needed
ZIP_FILE="/tmp/bw-cli.zip"

function check_bw_secrets_path() {
  if [ ! -f "$BW_SECRETS_PATH" ]; then
    echo "Bitwarden secrets file not found at path: $BW_SECRETS_PATH."
    exit 1
  fi
}

function download_cli() {
  echo "Downloading Bitwarden CLI..."
  wget -O "$ZIP_FILE" "$BW_DOWNLOAD_URL"
}

function install_bw_cli() {
  echo "Unzipping Bitwarden CLI to $INSTALL_DIR..."
  mkdir -p "$INSTALL_DIR"
  unzip -o "$ZIP_FILE" -d "$INSTALL_DIR"
}

function add_bw_path() {
  echo "Updating PATH to include $INSTALL_DIR..."
  if ! grep -q "$INSTALL_DIR" <<< "$PATH"; then
    echo "export PATH=\$PATH:$INSTALL_DIR" >> "$HOME/.zshrc"
    export PATH="$PATH:$INSTALL_DIR"
  fi
}

function check_bw_installation() {
  echo "Verifying Bitwarden CLI installation..."
  if command -v bw > /dev/null; then
    echo "Bitwarden CLI successfully installed! Version: $(bw --version)"
  else
    echo "Error: Bitwarden CLI installation failed."
  fi
}

function bw_login() {
    SECRET=$1
    export BW_CLIENTSECRET
    BW_CLIENTSECRET=$(gpg --decrypt "$SECRET" | jq -r '.client_secret')
    export BW_CLIENTID
    BW_CLIENTID=$(gpg --decrypt "$SECRET" | jq -r '.client_id')
    bw login --apikey
    unset BW_CLIENTID
    unset BW_CLIENTSECRET
    export BW_SESSION
    export BW_PASSWORD
    temp_file="$(mktemp)"
    gpg --decrypt "$BW_PWD" > "$temp_file"
    BW_SESSION=$(bw unlock --passwordfile "$temp_file" --raw)
    rm "$temp_file"
}

function bw_get_ssh_keys() {
    folder_id=$(bw list folders | jq -r '.[] | select (.name == "ssh") | .id')
    items=$(bw list items --folderid "$folder_id")
    item_id=$(echo "$items" | jq -r '.[].id')
    attachments=$(echo "$items" | jq '[.[].attachments[] | {attachment_id: .id, file_name: .fileName}]')

    for row in $(echo "$attachments" | jq -c '.[]'); do
        attachment_id=$(echo "$row" | jq -r '.attachment_id')
        file_name=$(echo "$row" | jq -r '.file_name')
        bw get attachment "$attachment_id" --itemid "$item_id" --output ~/.ssh/"${file_name}"
    done
}

download_cli
install_bw_cli
add_bw_path

echo "Cleaning up..."
rm -f "$ZIP_FILE"

check_bw_secrets_path
bw_login "$BW_SECRETS_PATH"
bw_get_ssh_keys
