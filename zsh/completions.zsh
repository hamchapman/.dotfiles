# All completion paths must be present before compinit builds its cache.
typeset -U fpath
fpath=(
  "${BREW_PREFIX}/share/zsh/site-functions"
  "${BREW_PREFIX}/share/zsh-completions"
  "$HOME/.zsh/completions"
  $fpath
)
autoload -Uz compinit
compinit

# The installed clap wrapper registers its dynamic handler when sourced. Do
# that directly so the first Tab works, without running jj during startup.
if [[ -r "${BREW_PREFIX}/share/zsh/site-functions/_jj" ]]; then
  source "${BREW_PREFIX}/share/zsh/site-functions/_jj"
fi

unsetopt nomatch
setopt auto_cd

unsetopt menu_complete # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# case and hyphen/underscore insensitive completion matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

unset CASE_SENSITIVE HYPHEN_INSENSITIVE
