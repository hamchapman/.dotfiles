# Specify Python version.
export PYENV_VERSION=3.10.7

export PIPX_BIN_DIR="$HOME/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"

# -U eliminates duplicates.
export -U PATH path
path=(
    $PIPX_BIN_DIR
    $PYENV_ROOT/{bin,shims}
    $path
)

# Updates the global python, if necessary, and installs/upgrades pipenv.
pybake() {
  # Install pyenv, if necessary.
  command -v pyenv > /dev/null || brew install pyenv

  # Install your preferred Python. Does nothing if $PYENV_VERSION hasn't
  # changed.
  pyenv install --skip-existing $PYENV_VERSION

  # Make it your default.
  pyenv global $PYENV_VERSION
  # Update pip.
  pip install -U pip

  # Install pipx (into ~/.local/bin) or update it. pipx is like brew, but for
  # Python.
  pip install -U --user pipx

  # Install or update pipenv.
  pipx ${${$( command -v pipenv ):+upgrade}:-install} pipenv
}