autoload -U compinit
compinit

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

# jj completions
source <(jj util completion zsh)
