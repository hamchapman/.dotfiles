## Git - see gitconfig for description of functionality
alias g='git s'
alias gp='git p'
alias gc='git c'
alias gl='git l'
alias ga='git add -p'
alias gs='git ss'
alias gb='git b'
alias grb='git rb'
alias grba='git rba'
alias ggo='git go'
alias gds='git ds'
alias grv='git rv'
alias gca='git ca'
alias gcaa='git caa'
alias gsu='git su'
alias gsui='git sui'
alias gtd='git td'
alias gpu='git pu'
alias gcm='git cm'
alias gf='git f'
alias glpr='git lpr'
alias glprc='git lpr | pbcopy'
alias gun='git undo'
alias gwip='git wip'
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
