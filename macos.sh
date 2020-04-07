#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -euo pipefail

asksure() {
	echo -n "Are you sure (Y/N)? "
	while read -r -n 1 -s answer; do
	  if [[ $answer = [YyNn] ]]; then
	    [[ $answer = [Yy] ]] && retval=0
	    [[ $answer = [Nn] ]] && retval=1
	    break
	  fi
	done

	echo # just a final linefeed, optics...

	return $retval
}

echo "Sign in to App Store"
open -a "App Store"

echo "Press y once you've signed into the App Store"

if asksure; then
	mas account

	retVal=$?
	if [ $retVal -ne 0 ]; then
	    echo "Failed to sign into App Store"
	    exit $retVal
	else
		echo "Signed into App Store"
	fi
else
	echo "Failed to sign into App Store"
	exit 1
fi

# Create file for secrets
touch $HOME/.dotfiles/zsh/secret

# Do some useful linking
ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global
ln -sf $HOME/.dotfiles/.gemrc $HOME/.gemrc

# Link Sublime Text theme to the correct place
mkdir -p $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham
ln -sf $HOME/.dotfiles/sublime/OceanicNext.tmTheme $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham/OceanicNext.tmTheme

# Link Sublime Text preferences to the correct place
ln -sf $HOME/.dotfiles/sublime/Preferences.sublime-settings $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings

# Add Terminal.app theme
open $HOME/.dotfiles/terminal_themes/Chalk.terminal

# Install some default software
brew bundle --file="$HOME/.dotfiles/Brewfile"
brew bundle --file="$HOME/.dotfiles/Brewfile.cask"

# Remove brew cruft
brew cleanup

# Ensure that Ruby gems directory exists
mkdir $HOME/.gem

# Install App Store apps
mas install 1091189122 # Bear
mas install 975937182 # Fantastical 2
mas install 904280696 # Things 3
mas install 1384080005 # Tweetbot 3

# Add ssh key to keychain
ssh-add -K $HOME/.ssh/id_ed25519

# Set many default settings
$HOME/.dotfiles/defaults.sh

open /usr/local/Caskroom/backblaze/latest/Backblaze\ Installer.app
