# VCS queries run outside the prompt path. Pending results show an ellipsis,
# never an old clean indicator, and redraw through ZLE when ready.
typeset -g _vcs_segment=''
typeset -g _vcs_fd=''
typeset -g _vcs_request_pwd=''
typeset -gi _vcs_epoch=0 _vcs_request_epoch=0

_vcs_find_root() {
  local d=$PWD
  REPLY=''
  while true; do
    # Git provides live branch/filesystem state in colocated repos without
    # snapshotting or signing a Jujutsu working-copy commit.
    if [[ -e "$d/.git" ]]; then
      REPLY="git:$d"
      return 0
    elif [[ -d "$d/.jj" ]]; then
      REPLY="jj:$d"
      return 0
    fi
    [[ "$d" == / ]] && return 1
    d=${d:h}
  done
}

_prompt_git() {
  local root=$1 out line head='' oid='' action='' dirty=0 ref
  out=$(GIT_OPTIONAL_LOCKS=0 command git -C "$root" status \
    --porcelain=2 --branch --ignore-submodules=dirty 2>/dev/null) || return
  [[ -n "$out" ]] || return

  local gitdir="$root/.git"
  if [[ -f "$gitdir" ]]; then
    IFS= read -r line < "$gitdir"
    gitdir=${line#gitdir: }
    [[ "$gitdir" == /* ]] || gitdir="$root/$gitdir"
  fi
  if [[ -d "$gitdir/rebase-merge" || -d "$gitdir/rebase-apply" ]]; then
    action=' (rebase)'
  elif [[ -f "$gitdir/MERGE_HEAD" ]]; then
    action=' (merge)'
  fi

  for line in "${(@f)out}"; do
    case $line in
      '# branch.head '*) head=${line#\# branch.head } ;;
      '# branch.oid '*) oid=${line#\# branch.oid } ;;
      '# '*) ;;
      *) dirty=1 ;;
    esac
  done
  if [[ "$head" == '(detached)' || -z "$head" ]]; then
    ref="${DETACHED}${oid[1,8]}"
  else
    ref="${BRANCH}${head}"
  fi
  ref="${ref//\%/%%}${action}"
  if (( dirty )); then
    print -r -- " %F{red}${ref}%f"
  else
    print -r -- " %F{green}${ref}%f"
  fi
}

_prompt_jj() {
  # No live Git working tree is available in standalone jj repos. Explicitly
  # label the recorded snapshot and make no claim about filesystem cleanliness.
  local ref
  ref=$(command jj -R "$1" log --no-pager -r @ --no-graph \
    --ignore-working-copy -T 'bookmarks.join(",") ++ " " ++ change_id.shortest(8)' \
    2>/dev/null) || return
  [[ -n "$ref" ]] && print -r -- " %F{cyan}jj snapshot:${ref//\%/%%}%f"
}

_vcs_stop() {
  if [[ -n "$_vcs_fd" ]]; then
    zle -F "$_vcs_fd" 2>/dev/null
    exec {_vcs_fd}<&-
    _vcs_fd=''
  fi
}

_vcs_ready() {
  local fd=$1 segment=''
  [[ "$fd" == "$_vcs_fd" ]] || return
  local request_pwd=$_vcs_request_pwd request_epoch=$_vcs_request_epoch
  # EOF can arrive with the final line; read it before closing the descriptor.
  IFS= read -r -u "$fd" segment
  _vcs_stop
  if [[ "$PWD" == "$request_pwd" && $_vcs_epoch == $request_epoch ]]; then
    _vcs_segment=$segment
  else
    # A command or directory change made this query obsolete. Start one fresh
    # query now, rather than piling up Git processes while the user is typing.
    _vcs_update
  fi
  zle && zle reset-prompt
}

_vcs_update() {
  _vcs_segment=''
  _vcs_find_root || return 0
  _vcs_segment=' %F{yellow}…%f'
  [[ -n "$_vcs_fd" ]] && return 0
  local kind=${REPLY%%:*} root=${REPLY#*:}
  _vcs_request_pwd=$PWD
  _vcs_request_epoch=$_vcs_epoch
  exec {_vcs_fd}< <(
    if [[ "$kind" == git ]]; then
      _prompt_git "$root"
    else
      _prompt_jj "$root"
    fi
  )
  zle -F "$_vcs_fd" _vcs_ready
}

_vcs_invalidate() {
  (( _vcs_epoch += 1 ))
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _vcs_invalidate
add-zsh-hook zshexit _vcs_stop
