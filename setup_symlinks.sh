#!/bin/bash

# Dotfiles symlink setup script
# This script creates symlinks from your dotfiles repository to the appropriate locations in your home directory

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located (should be the dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}Setting up dotfiles symlinks...${NC}"
echo -e "${BLUE}Dotfiles directory: ${DOTFILES_DIR}${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    # Create target directory if it doesn't exist
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${YELLOW}Creating directory: $target_dir${NC}"
        mkdir -p "$target_dir"
    fi

    # If target already exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo -e "${YELLOW}Backing up existing file: $target -> $target.backup${NC}"
        mv "$target" "$target.backup"
    elif [[ -L "$target" ]]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    fi

    # Create the symlink
    echo -e "${GREEN}Creating symlink: $target -> $source${NC}"
    ln -sf "$source" "$target"
}

# Bash configuration
if [[ -f "$DOTFILES_DIR/bash/.bashrc" ]]; then
    create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
fi

# Tmux configuration
if [[ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]]; then
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Neovim configuration (entire directory)
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# VS Code configuration
if [[ -d "$DOTFILES_DIR/vscode" ]]; then
    # Determine VS Code config directory based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
    else
        VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    fi

    if [[ -f "$DOTFILES_DIR/vscode/settings.json" ]]; then
        create_symlink "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    fi

    if [[ -f "$DOTFILES_DIR/vscode/keybindings.json" ]]; then
        create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
    fi
fi

# WezTerm configuration
if [[ -f "$DOTFILES_DIR/wezterm/wezterm.lua" ]]; then
    create_symlink "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
fi

echo -e "${GREEN}✓ Dotfiles symlink setup complete!${NC}"
echo -e "${BLUE}Note: Original files have been backed up with .backup extension if they existed.${NC}"
