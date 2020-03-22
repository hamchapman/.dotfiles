autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%b" # just the branch name
zstyle ':vcs_info:git*' actionformats "%b (%a)" # branch name with action for things like rebase
zstyle ':vcs_info:git*' nvcsformats "" # nothing if no vcs

prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      ref="%F{red}${ref}"
    else
      ref="%F{green}${ref}"
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    print -n "$ref"
  fi
}
