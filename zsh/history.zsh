[[ -n "$HISTFILE" ]] || HISTFILE=$HOME/.zsh_history

HISTSIZE=200000
SAVEHIST=100000

case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history extended_history hist_expire_dups_first
setopt hist_ignore_dups hist_ignore_space hist_no_store hist_verify
# SHARE_HISTORY already appends commands; do not combine it with INC_APPEND_HISTORY.
setopt share_history

bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
bindkey '^R' history-incremental-search-backward

# Fetch the selected event without interpreting command text with printf.
if [[ -o zle && -t 0 && -r "${BREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" ]]; then
  : ${FZF_CTRL_R_OPTS:='--exact --preview-window=hidden'}
  source "${BREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
fi
