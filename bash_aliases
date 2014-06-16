##################################
# Aliases
##################################

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias ll='ls -alF'
alias la='ls -A'
# alias l='ls -CF'
alias l='ll'

# Git alias
alias g='git status'
alias gd='git diff'
alias gc='git checkout'
alias gap='git add --patch'
alias gdc='git diff --cached'

alias gb='git branch'

alias gup="git pull"
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias grv='git remote -v'

alias ga="git add .;git commit --amend -m"                                                                                                                                                    
alias gm="git add .;git commit -m"  

alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias glc='git log -1 --pretty=format:"%Cgreen%ci %Cred%cr%Creset" '
alias galias='git config --get-regexp alias'

# Other aliases
alias tmux="TERM=screen-256color-bce tmux"

alias sb='source ~/.bashrc'
alias sa='source ~/.aliases'
alias dot="cd ~/projects/dotfiles"
