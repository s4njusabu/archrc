#!/bin/bash

set -e

# System update

sudo pacman -Syu

# Main packages

sudo pacman -S --needed base-devel git ghostty rustup flatpak zellij tmux lsof code tree fastfetch bat python podman-docker uv curl unzip unrar

# Browsers

sudo pacman -S --needed firefox
paru -S --needed brave-bin

# Smart Zsh

sudo pacman -S --needed zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting


# Text editor

sudo pacman -S --needed vim neovim

# Qemu Virt-manager
sudo pacman -S --needed qemu-desktop virt-manager dnsmasq 
