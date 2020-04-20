## Git
alias g='git status'
alias gc='git commit --verbose --cleanup=scissors'
alias gl='git l'
alias ga='git add -p'
alias gs='git s'
alias gb='git checkout -'
alias grb='git rb'
alias grba='git rba'
alias ggo='git go'
alias gds='git diff --staged'
alias grv='git remote -v'
alias gca='git commit --amend --verbose --no-edit --cleanup=scissors'
alias gcaa='git commit --amend --verbose --cleanup=scissors'
alias gsu='git submodule update'
alias gsui='git submodule update -i'
alias gcon='git contributors'
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

## macOS
alias o='open .'

## Misc
alias reload='source ~/.zshrc'
alias be='bundle exec'
alias prune='brew cleanup && gem cleanup && docker system prune && xcrun simctl delete unavailable'
alias tdesk='if (defaults read com.apple.finder CreateDesktop | grep -q true); then defaults write com.apple.finder CreateDesktop false; else defaults write com.apple.finder CreateDesktop true; fi
killall Finder /System/Library/CoreServices/Finder.app'
