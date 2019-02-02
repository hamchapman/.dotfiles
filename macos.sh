#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -euo pipefail

touch ./zsh/secret

# Do some useful linking
ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global

# Link Sublime Text theme to the correct place
mkdir -p $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham
ln -sf $HOME/.dotfiles/sublime/OceanicNext.tmTheme $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham/OceanicNext.tmTheme

# Add Terminal.app theme
open ./terminal_themes/Chalk.terminal

# Install some default software
brew bundle --file="./Brewfile"
brew bundle --file="./Brewfile.cask"

ssh-add -K ~/.ssh/id_ed25519

# Set many default settings
./defaults.sh
