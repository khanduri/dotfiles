##################################
# Aliases
##################################

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias cd..='cd ..'
alias l='ll'
alias ll='ls -alF'
alias la='ls -A'

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

# alias ga="git add .;git commit --amend -m"                                                                                                                                                    
# alias gm="git add .;git commit -m"  
alias ga="git commit --amend --no-edit"

alias galias='git config --get-regexp alias'
alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias glc='git log -1 --pretty=format:"%Cgreen%ci %Cred%cr%Creset" '
alias glp="git log --format='%Cgreen%h%Creset %C(yellow)%s%Creset %C(red)(%ae)%Creset' --no-merges "
alias gm="git merge --no-commit --no-ff"

# Other aliases
alias tmux="TERM=screen-256color-bce tmux"

alias sb='source ~/.bashrc'
alias sa='source ~/.aliases'

alias dot="pset r b g;cd ~/projects/dotfiles;git pull"

alias cdios='pset r y g;deactivate;cd ~/projects/iosAppPlayground/'
alias cdheroku='pset r y g;deactivate;cd ~/projects/herokuPlayground/;source venv/bin/activate'
alias cdflask='pset r y g;deactivate;cd ~/projects/herokuPlayground/flask/;source venv/bin/activate'
alias blog="pset r y g;cd ~/projects/blog/khanduri.github.io/;git pull"
alias myos="pset r y g;cd ~/projects/opensource/"
alias yeoman="pset r y g;cd ~/projects/yeoman/"

alias siteops='deactivate;pset y c y;cd ~/projects/jawbone/siteops;git pull'
alias cdjaw='deactivate;pset y c y;cd ~/projects/jawbone/srv;source tools/virtualenv/srv-env/bin/activate'
alias cdjap='deactivate;pset y c g;cd ~/projects/jawbone/pkhanduri_srv;source tools/virtualenv/srv-env/bin/activate'

alias gupmaster='cdjap;git fetch upstream; git checkout master; git rebase upstream/master master; git push origin master'
alias gupma='cdjap;git fetch upstream; git checkout master-armstrong; git rebase upstream/master-armstrong master-armstrong; git push origin master-armstrong'

alias cdsolr='cd /usr/local/Cellar/solr/4.7.2/libexec/example/'
alias startsolr='java -DzkRun -DnumShards=1 -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -jar start.jar'

alias dz='psql -h wearhaus.c0s0yd7udzgh.us-east-1.redshift.amazonaws.com -p 5439 datazoo -U pkhanduri'
