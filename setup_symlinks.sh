#!/bin/bash

set -e

# Default nvim config
NVIM_CONFIG="lazyvim"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --nvim=*)
            NVIM_CONFIG="${arg#*=}"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--nvim=<kickstart|lazyvim|old>]"
            exit 0
            ;;
    esac
done

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

create_symlink() {
    local source="$1"
    local target="$2"
    local target_dir="$(dirname "$target")"

    mkdir -p "$target_dir"

    if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "$target.backup"
    fi

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

# Neovim configuration
NVIM_SOURCE="$DOTFILES_DIR/nvim_$NVIM_CONFIG"
if [[ -d "$NVIM_SOURCE" ]]; then
    create_symlink "$NVIM_SOURCE" "$HOME/.config/nvim"
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

echo "Done."
