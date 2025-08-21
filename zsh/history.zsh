if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=1000000000
SAVEHIST=1000000

case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_no_store
setopt hist_verify
# setopt inc_append_history # should not be set if share_history is set, as per
# https://zsh-manual.netlify.app/options
setopt share_history # share command history data

# Borrowed from oh-my-zsh (ish) for history

bindkey -e # Use emacs key bindings
# bindkey '^r' history-incremental-search-backward # Commented out to allow fzf history search

autoload -Uz up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

# fzf-based history searching

# do nothing if fzf is not installed
(( ! $+commands[fzf] )) && return

# Bind for fzf history search
(( ! ${+ZSH_FZF_HISTORY_SEARCH_BIND} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_BIND='^r'

# Args for fzf
(( ! ${+ZSH_FZF_HISTORY_SEARCH_FZF_ARGS} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_FZF_ARGS='+s +m -x -e --preview-window=hidden'

# Extra args for fzf
(( ! ${+ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS=''

# Cursor to end-of-line
(( ! ${+ZSH_FZF_HISTORY_SEARCH_END_OF_LINE} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=''

# Include event numbers
(( ! ${+ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=1

# Include full date timestamps in ISO8601 `yyyy-mm-dd hh:mm' format
(( ! ${+ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=1

# Remove duplicate entries in history
(( ! ${+ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES} )) &&
typeset -g ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=''

fzf_history_search() {
  setopt extendedglob

  FC_ARGS="-l"
  CANDIDATE_LEADING_FIELDS=2

  if (( ! $ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS )); then
    FC_ARGS+=" -n"
    ((CANDIDATE_LEADING_FIELDS--))
  fi

  if (( $ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH )); then
    FC_ARGS+=" -i"
    ((CANDIDATE_LEADING_FIELDS+=2))
  fi

  history_cmd="fc ${=FC_ARGS} -1 0"

  if [ -n "${ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES}" ];then
    if (( $+commands[awk] )); then
      history_cmd="$history_cmd | awk '!seen[\$0]++'"
    else
      # In case awk is not installed fallback to uniq. It will only remove
      # commands that are repeated consecutively.
      history_cmd="$history_cmd | uniq"
    fi
  fi

  candidates=(${(f)"$(eval $history_cmd | fzf ${=ZSH_FZF_HISTORY_SEARCH_FZF_ARGS} ${=ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS} -q "$BUFFER")"})
  local ret=$?
  if [ -n "$candidates" ]; then
    if (( $CANDIDATE_LEADING_FIELDS != 1 )); then
      BUFFER="${candidates[@]/(#m)[0-9 \-\:]##/${${(As: :)MATCH}[${CANDIDATE_LEADING_FIELDS},-1]}}"
    else
      BUFFER="${candidates[@]}"
    fi
    BUFFER=$(printf "${BUFFER[@]//\\\\n/\\\\\\n}")
    zle vi-fetch-history -n $BUFFER
    if [ -n "${ZSH_FZF_HISTORY_SEARCH_END_OF_LINE}" ]; then
      zle end-of-line
    fi
  fi
  zle reset-prompt
  return $ret
}

autoload fzf_history_search
zle -N fzf_history_search

bindkey $ZSH_FZF_HISTORY_SEARCH_BIND fzf_history_search
