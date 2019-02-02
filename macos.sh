#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -euo pipefail

# Do some useful linking
ln -s $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -s $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global

# Link Sublime Text theme to the correct place
mkdir $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham
ln $HOME/.dotfiles/sublime/OceanicNext.tmTheme $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham/OceanicNext.tmTheme

# Add Terminal.app theme
open ./terminal_themes/Chalk.terminal

# Install some default software
brew bundle --file="./Brewfile"
brew bundle --file="./Brewfile.cask"

# Set many default settings
./defaults.sh
