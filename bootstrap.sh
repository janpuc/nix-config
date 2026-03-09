#!/usr/bin/env zsh

set -e

HOSTNAME=$1
NIX_CONFIG_REPO="https://github.com/janpuc/nix-config.git"
NIX_CONFIG_DIR="$HOME/nix-config"

info() {
    echo "INFO: $1"
}

if [ -z "$HOSTNAME" ]; then
    echo "ERROR: No hostname provided."
    echo "Usage: $0 <hostname>"
    exit 1
fi

if [ ! $(uname -o) -eq "Darwin" ]; then
    echo "ERROR: Only Darwin supported at this point in time."
    exit 1
fi

info "Starting bootstrap process for hostname: $HOSTNAME"

info "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    info "Xcode Command Line Tools not found. Please install them first by running:"
    echo "xcode-select --install"
    read -p "Press [Enter] to continue after installation..."
else
    info "Xcode Command Line Tools are already installed."
fi

info "Checking for Nix installation..."
if ! command -v nix &>/dev/null; then
    info "Nix not found. Installing Nix..."
    ## This doesn't work for some reason.
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
    #curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/v3.11.3/nix-installer-aarch64-darwin -o nix-install
    chmod +x nix-install
    ./nix-install install --determinate --no-confirm
    rm -rf nix-install
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    info "Nix is already installed."
fi

if [ -f /etc/zshrc ]; then
  info "Moving default 'zshrc' to 'zshrc.before-nix-darwin'."
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
fi

if [ -f /etc/zprofile ]; then
  info "Moving default 'zprofile' to 'zprofile.before-nix-darwin'."
  sudo mv /etc/zprofile /etc/zprofile.before-nix-darwin
fi

info "Cloning Nix configuration from $NIX_CONFIG_REPO..."
if [ -d "$NIX_CONFIG_DIR" ]; then
    info "Directory $NIX_CONFIG_DIR already exists. Skipping clone."
else
    git clone "$NIX_CONFIG_REPO" "$NIX_CONFIG_DIR"
fi

cd "$NIX_CONFIG_DIR"
git remote set-url origin git@github.com:janpuc/nix-config.git

info "Running initial nix-darwin switch for $HOSTNAME..."
sudo "$(nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake .#$HOSTNAME 2>&1 > /dev/null | cut -d ":" -f1)" switch --flake .#$HOSTNAME

info "Running initial home-manager switch..."
nix run nixpkgs#home-manager -- switch --flake .

info "Switching to fish..."
chsh -s /run/current-system/sw/bin/fish

echo
info "--------------------------------------------------------"
info "✅ Stage 1 Bootstrap Complete!"
info "--------------------------------------------------------"
info "Next steps:"
info "1. Restart your terminal or source your new shell configuration."
info "2. Sign in to the 1Password CLI: eval \$(op signin)"
info "3. Configure SSH by fetching your key from 1Password."
