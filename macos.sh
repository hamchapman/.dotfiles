#!/usr/bin/env bash
# This is a script for bootstrapping macOS setup

set -eo pipefail

asksure() {
  local msg="${1}"
	echo -n "${msg} (y/n) "
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

echo "Please provide password for changes that require sudo"

# Ask for the administrator password upfront
sudo -v

echo "Sign in to App Store"
open -a "App Store"

asksure "Press y once you've signed into the App Store"

# Install homebrew
echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

BREW_BIN=""

if [[ -f "/usr/local/bin/brew" ]]; then
  BREW_BIN="/usr/local/bin/brew"
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
  BREW_BIN="/opt/homebrew/bin/brew"
else
  echo "brew not found in one of the expected locations"
  exit 1
fi

BREW_PREFIX=$("${BREW_BIN}" --prefix)

# Create file for secrets, if it doesn't already exist
SECRETS_FILE_PATH="$HOME/.dotfiles/zsh/secret.zsh"
if [ ! -f "${SECRETS_FILE_PATH}" ]; then
  touch "${SECRETS_FILE_PATH}"
fi

# Substitute proper `BREW_PREFIX` into gitconfig template
cp $HOME/.dotfiles/git/gitconfig.template $HOME/.dotfiles/git/gitconfig
sed -i '' -e "s|___BREW_PREFIX___|${BREW_PREFIX}|" $HOME/.dotfiles/git/gitconfig

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
"${BREW_BIN}" tap homebrew/cask-versions
"${BREW_BIN}" bundle --file="$HOME/.dotfiles/Brewfile"
"${BREW_BIN}" bundle --file="$HOME/.dotfiles/Brewfile.cask"

# Remove brew cruft
"${BREW_BIN}" cleanup

# Store brew prefix in brew.zsh
echo "export BREW_PREFIX=\"${BREW_PREFIX}\"" > zsh/brew.zsh

# We need to open VSCode to make the required directories be created
open "/Applications/Visual Studio Code.app"

# Ensure VSCode settings are in the right place
ln -sf "$HOME/.dotfiles/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

# Ensure that Ruby gems directory exists
mkdir -p "$HOME/.gem"

"${BREW_PREFIX}/bin/mas" install 409183694 # Keynote
"${BREW_PREFIX}/bin/mas" install 409201541 # Pages
"${BREW_PREFIX}/bin/mas" install 409203825 # Numbers
"${BREW_PREFIX}/bin/mas" install 904280696 # Things 3
"${BREW_PREFIX}/bin/mas" install 1384080005 # Tweetbot 3
"${BREW_PREFIX}/bin/mas" install 1475387142 # Tailscale
"${BREW_PREFIX}/bin/mas" install 1295203466 # Microsoft Remote Desktop

# Add ssh key to keychain
ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519

# Set many default settings
$HOME/.dotfiles/defaults.sh

# Install stable ruby
install_stable_ruby() (
  # 1. Get latest stable Ruby version
  local ruby_ver
  ruby_ver=$(ruby-install --latest | awk 'flag{ if (/jruby:/){printf "%s", buf; flag=0; buf=""} else buf = buf $0 ORS}; /ruby:/{flag=1}' | tail -1 | tr -d '[:space:]')

  # 2. Install the latest stable Ruby version, if not already installed
  if [[ -d "$HOME/.rubies/ruby-${ruby_ver}" ]]; then
    echo "Ruby ${ruby_ver} already installed"
  else
    echo "Installing Ruby ${ruby_ver}"
    ruby-install ruby $ruby_ver
  fi

  # 3. Ensure that the `chruby` function is available
  source "${BREW_PREFIX}/opt/chruby/share/chruby/chruby.sh"

  # 4. Activate the installed stable Ruby version
  chruby ruby-$ruby_ver

  # 5. Ensure DEFAULT_STABLE_RUBY env var is up-to-date
  sed -i '' -e "s/export DEFAULT_STABLE_RUBY=\"$DEFAULT_STABLE_RUBY\"/export DEFAULT_STABLE_RUBY=\"${ruby_ver}\"/" $HOME/.dotfiles/zsh/zshrc
)
install_stable_ruby

# Install xcversion to enable nice Xcode installs
gem install xcode-install

# Install latest Xcode

# Call this once on its own to trigger any required login
xcversion list

# Proceed with install latest Xcode
latest_xcode_version=`xcversion list | grep -Ei '^[0-9\.]+$' | tail -1`
echo "Installing Xcode ${latest_xcode_version}"
xcversion install "${latest_xcode_version}"

# Install sourcekitten now that Xcode is installed
"${BREW_BIN}" install sourcekitten

# Create NVM's working directory
mkdir -p "$HOME/.nvm"

# Install Node version(s)
nvm install --lts

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Open Backblaze because it's easy to forget to set this up otherwise
open "${BREW_PREFIX}/Caskroom/backblaze"

# Ensure .dotfiles repo has the correct URL set (ssh, not https)
ensure_correct_dotfiles_remote_url() (
  local desired_repo_url="git@github.com:hamchapman/.dotfiles.git"
  local existing_url=''
  existing_url="$(git config "remote.origin.url")" || true

  if [[ "${desired_repo_url}" == "${existing_url}" ]]; then
    # no-op - we are in a good state
    true
  else
    git remote set-url origin "${desired_repo_url}"
  fi
)
ensure_correct_dotfiles_remote_url
