GO_VERSION ?= 1.23.3
BW_SECRETS_PATH ?= ""
BW_PWD_PATH ?= ""
BW_SECRETS_FOLDER ?= ""

.PHONY: all
all: install_libs download_secrets set_zsh_default

.PHONY: install_libs
install_libs:
	@echo "Installing dependencies..."
	bash scripts/install_libs.sh $(GO_VERSION)

.PHONY: set_zsh_default
set_zsh_default: install_libs
	@echo "Setting Zsh as the default shell..."
	bash scripts/set_zsh_default.sh

# Download secrets using Bitwarden
.PHONY: download_secrets
download_secrets:
ifeq ($(BW_SECRETS_PATH), "")
	@echo "Error: BW_SECRETS_PATH is not set. Please provide the path to the Bitwarden secrets file." >&2
	@exit 1
endif
ifeq ($(BW_SECRETS_FOLDER), "")
	@echo "Error: BW_SECRETS_FOLDER is not set. Provide the folder used in Bitwarden." >&2
	@exit 1
endif
	@echo "Downloading secrets using Bitwarden..."
	bash scripts/download_secrets.sh $(BW_SECRETS_PATH) $(BW_PWD_PATH) $(BW_SECRETS_FOLDER)

# Help target to display usage
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make all               Run all tasks (default)"
	@echo "  make install_libs      Install dependencies and configure the environment"
	@echo "  make set_zsh_default   Set Zsh as the default shell"
	@echo "  make download_secrets  Download secrets using Bitwarden"
	@echo "  make cleanup           Remove temporary files"
