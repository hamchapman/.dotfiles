## Git - see gitconfig for description of functionality

git_aliases=("${(@f)$(git al)}")

for al in ${git_aliases[@]}; do
  just_alias=$(echo $al | cut -f1 -d' ')
  alias "g$just_alias"="git $just_alias"
done

alias g='git s'
alias gtt='gittower .'

## cd shortcuts

# General
alias xdo='cd ~/.dotfiles'
alias xdf='cd ~/.dotfiles'
alias xpr='cd ~/projects'
alias xsc='cd ~/scratch'

# Ditto
alias d='cd ~/ditto'
alias ddd='cd ~/ditto/ditto'

# Work
alias gg='cd ~/ditto/ditto'

## Editor
alias s='subl .'
alias c='code .'
alias z='zed .'

## macOS
alias o='open .'

## Misc
alias reload='source ~/.zshrc'
alias be='bundle exec'
alias ru="chruby ruby-${DEFAULT_STABLE_RUBY}"
alias prune='brew cleanup && gem cleanup && docker system prune && xcrun simctl delete unavailable'
alias tdesk='if (defaults read com.apple.finder CreateDesktop | grep -q true); then defaults write com.apple.finder CreateDesktop false; else defaults write com.apple.finder CreateDesktop true; fi
killall Finder /System/Library/CoreServices/Finder.app'
