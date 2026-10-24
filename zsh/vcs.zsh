# Fast VCS prompt segment: git and jj, each with a single subprocess call.
##
# Here we're doing exactly one VCS subprocess call per prompt - git:
# `status --porcelain=2 --branch`; jj: one templated `jj log` - and only
# forks at all once a repo root is actually found (the upward search for
# .jj/.git is pure zsh, no forks).
#
# $BRANCH / $DETACHED are optional icon/text prefixes (left empty by
# default, same as before) you can set elsewhere in your config.

_vcs_find_root() {
  # Walk up from $PWD looking for the nearest .jj or .git. jj wins if a
  # directory has both (a colocated repo) since jj is the source of truth
  # for working-copy state there.
  local d="$PWD"
  while true; do
    if [[ -d "$d/.jj" ]]; then
      print -r -- "jj:$d"
      return
    elif [[ -e "$d/.git" ]]; then
      print -r -- "git:$d"
      return
    fi
    [[ "$d" == "/" ]] && return
    d="${d:h}"
  done
}

_prompt_git() {
  # $1 = git root dir (already found by the pure-zsh upward walk, so we
  # don't need to fork git again just to locate it).
  local root="$1"
  local out ref line dirty=0 head="" action=""
  out="$(git status --porcelain=2 --branch --ignore-submodules=dirty 2>/dev/null)" || return
  [[ -z "$out" ]] && return

  # Only check for an in-progress rebase/merge when .git is a plain
  # directory. Worktrees/submodules use a .git *file* pointing elsewhere;
  # skip action detection there rather than forking git again just for this.
  local gitdir="$root/.git"
  if [[ -d "$gitdir" ]]; then
    if [[ -d "$gitdir/rebase-merge" || -d "$gitdir/rebase-apply" ]]; then
      action="rebase"
    elif [[ -f "$gitdir/MERGE_HEAD" ]]; then
      action="merge"
    fi
  fi

  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*) head="${line#\# branch.head }" ;;
      "# branch.oid "*) [[ -z "$head" || "$head" == "(detached)" ]] && ref="${${line#\# branch.oid }[1,8]}" ;;
      "#"*) ;; # other header lines, ignore
      *) dirty=1 ;;
    esac
  done <<< "$out"

  if [[ "$head" == "(detached)" || -z "$head" ]]; then
    ref="$DETACHED ${ref:-?}"
  else
    ref="$BRANCH $head"
  fi
  [[ -n "$action" ]] && ref="$ref ($action)"

  if (( dirty )); then
    print -n "%F{red}${ref}%f"
  else
    print -n "%F{green}${ref}%f"
  fi
}

_prompt_jj() {
  # One templated `jj log` call gives us the bookmark (git "branch"
  # equivalent), a short change id (for the "detached"/no-bookmark case,
  # like git's short commit hash), and whether @ is empty. A non-empty
  # working-copy commit is jj's closest equivalent of git's "dirty
  # worktree" - there's no index/staging distinction in jj, so as soon as
  # you touch a file it's recorded into @, same signal git gives you via
  # an uncommitted diff.
  local out bookmark change_id empty_flag ref
  out="$(jj log --no-pager -r @ --no-graph --ignore-working-copy \
    -T 'bookmarks.join(",") ++ "|||" ++ change_id.shortest(8) ++ "|||" ++ empty' \
    2>/dev/null)" || return
  [[ -z "$out" ]] && return

  local parts
  parts=("${(@s:|||:)out}")
  bookmark="${parts[1]}"
  change_id="${parts[2]}"
  empty_flag="${parts[3]}"

  if [[ -n "$bookmark" ]]; then
    ref="$BRANCH $bookmark"
  else
    ref="$DETACHED $change_id"
  fi

  if [[ "$empty_flag" == "false" ]]; then
    print -n "%F{red}${ref}%f"
  else
    print -n "%F{green}${ref}%f"
  fi
}

prompt_vcs() {
  local found kind root
  found="$(_vcs_find_root)"
  [[ -z "$found" ]] && return
  kind="${found%%:*}"
  root="${found#*:}"

  if [[ "$kind" == "jj" ]]; then
    _prompt_jj
  else
    _prompt_git "$root"
  fi
}
