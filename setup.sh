#!/bin/bash

set -e

print_colored() {
    echo -e "\e[1;34m$1\e[0m"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_colored "Updating system..."
sudo dnf update -y

print_colored "Installing ZSH and other packages..."
PACKAGES=(
    "zsh"
    "git"
    "curl"
    "wget"
    "vim"
    "neovim"
    "tmux"
    "htop"
    # Add more packages as needed
)

sudo dnf install -y "${PACKAGES[@]}"

print_colored "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_colored "Oh My Zsh is already installed. Skipping..."
fi

print_colored "Installing zsh-syntax-highlighting..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    print_colored "zsh-syntax-highlighting is already installed. Skipping..."
fi

if ! grep -q "plugins=(.*zsh-syntax-highlighting.*)" "$HOME/.zshrc"; then
    sed -i 's/plugins=(/plugins=(zsh-syntax-highlighting /' "$HOME/.zshrc"
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    print_colored "Setting ZSH as the default shell..."
    chsh -s "$(which zsh)"
else
    print_colored "ZSH is already the default shell."
fi

print_colored "Done?"
