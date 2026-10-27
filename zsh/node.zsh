# Select Node lazily, including after cd. Explicit nvm commands remain usable
# when a project's requested version is missing and needs to be installed.
export NVM_DIR="$HOME/.nvm"
[[ -r "${BREW_PREFIX}/opt/nvm/nvm.sh" ]] || return

typeset -g _nvm_loaded=${_nvm_loaded:-0}
typeset -g _nvm_context=${_nvm_context:-}

_nvm_arm() {
  node() { _nvm_activate && command node "$@"; }
  npm() { _nvm_activate && command npm "$@"; }
  npx() { _nvm_activate && command npx "$@"; }
}

_nvm_load() {
  (( _nvm_loaded )) && return 0
  unfunction nvm 2>/dev/null
  source "${BREW_PREFIX}/opt/nvm/nvm.sh" --no-use || return
  functions[_nvm_native]=$functions[nvm]
  nvm() { _nvm_dispatch "$@"; }
  _nvm_loaded=1
}

_nvm_dispatch() {
  # NVM calls itself internally. Only the outer call manages our wrappers.
  if (( ${_nvm_running:-0} )); then
    _nvm_native "$@"
    return $?
  fi
  local armed=${+functions[node]} result
  unfunction node npm npx 2>/dev/null
  _nvm_load || { (( armed )) && _nvm_arm; return 1; }
  local _nvm_running=1
  _nvm_native "$@"
  result=$?
  case $1 in
    use|install|deactivate)
      (( result && armed )) && _nvm_arm ;;
    *) (( armed )) && _nvm_arm ;;
  esac
  return $result
}

_nvm_activate() {
  # NVM calls node/npm itself; remove wrappers to avoid recursive activation.
  unfunction node npm npx 2>/dev/null
  local result rcfile context
  _nvm_load
  result=$?
  if (( result == 0 )); then
    rcfile=$(nvm_find_nvmrc)
    if [[ -n "$rcfile" ]]; then
      context="$rcfile:$(<"$rcfile")"
    elif [[ -r "$NVM_DIR/alias/default" ]]; then
      context="default:$(<"$NVM_DIR/alias/default")"
    else
      context=default
    fi
    if [[ "$context" == "$_nvm_context" && -n "$NVM_BIN" ]]; then
      return 0
    fi
    if [[ -n "$rcfile" ]]; then
      nvm use --silent
    else
      nvm use --silent default
    fi
    result=$?
  fi
  if (( result )); then
    # Retain wrappers so another attempt cannot silently run a different Node.
    _nvm_arm
    print -u2 -r -- "Could not select Node (${rcfile:-NVM default}). Use nvm install or nvm use <version>."
    return $result
  fi
  _nvm_context=$context
}

if (( ! _nvm_loaded )); then
  nvm() { _nvm_dispatch "$@"; }
fi

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _nvm_arm
_nvm_arm
