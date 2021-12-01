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

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Create file for secrets
touch $HOME/.dotfiles/zsh/secret.zsh

# Do some useful linking
ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
ln -sf $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global
ln -sf $HOME/.dotfiles/.gemrc $HOME/.gemrc

# Link Sublime Text theme to the correct place
mkdir -p "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Ham"
ln -sf $HOME/.dotfiles/sublime/OceanicNext.tmTheme $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Ham/OceanicNext.tmTheme

# Link Sublime Text preferences to the correct place
ln -sf $HOME/.dotfiles/sublime/Preferences.sublime-settings $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings

# Add Terminal.app theme
open $HOME/.dotfiles/terminal_themes/Chalk.terminal

# Install some default software
/opt/homebrew/bin/brew tap homebrew/cask-versions
/opt/homebrew/bin/brew bundle --file="$HOME/.dotfiles/Brewfile"
/opt/homebrew/bin/brew bundle --file="$HOME/.dotfiles/Brewfile.cask"

# Remove brew cruft
/opt/homebrew/bin/brew cleanup

# Ensure VSCode settings are in the right place
ln -sf $HOME/.dotfiles/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json

# Reload
source "$HOME/.zshrc"

# Ensure that Ruby gems directory exists
mkdir -p "$HOME/.gem"

# Install App Store apps
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

mas install 409183694 # Keynote
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 904280696 # Things 3
mas install 1384080005 # Tweetbot 3
mas install 1475387142 # Tailscale
mas install 1295203466 # Microsoft Remote Desktop

# Add ssh key to keychain
ssh-add -K $HOME/.ssh/id_ed25519

# Set many default settings
$HOME/.dotfiles/defaults.sh

# Install stable ruby

# 1. Get latest stable Ruby version
local ruby_ver
ruby_ver=$(ruby-install --latest | awk 'flag{ if (/jruby:/){printf "%s", buf; flag=0; buf=""} else buf = buf $0 ORS}; /ruby:/{flag=1}' | tail -1 | tr -d '[:space:]')

# 2. Install the latest stable Ruby version
echo "Installing Ruby ${ruby_ver}"
ruby-install ruby $ruby_ver

# 3. Reload
source "$HOME/.zshrc"

# 4. Activate to installed stable Ruby version
chruby ruby-$ruby_ver

# 5. Ensure DEFAULT_STABLE_RUBY env var is up-to-date
sed -i '' -e "s/export DEFAULT_STABLE_RUBY=\"$DEFAULT_STABLE_RUBY\"/export DEFAULT_STABLE_RUBY=\"${ruby_ver}\"/" $HOME/.dotfiles/zsh/zshrc

# Install xcversion to enable nice Xcode installs
gem install xcode-install

# Install latest Xcode
local latest_version
latest_version=`xcversion list | grep -Ei '^[0-9\.]+$' | tail -1`
echo "Installing Xcode ${latest_version}"
xcversion install "${latest_version}"

# Install sourcekitten now that Xcode is installed
/opt/homebrew/bin/brew install sourcekitten

# Create NVM's working directory
mkdir -p "$HOME/.nvm"

# Install Node version(s)
nvm install --lts

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

open /usr/local/Caskroom/backblaze
