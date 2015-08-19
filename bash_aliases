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
alias ga="git commit --amend --no-edit"
alias gb='git branch'
alias gc='git checkout'
alias gd='git diff'
alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias gm="git merge --no-commit --no-ff"
alias gs='git show --format="%aN <%aE>"'
alias gdc='git diff --cached'

alias gp="git pull"
alias gap='git add --patch'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias glc='git log -1 --pretty=format:"%Cgreen%ci %Cred%cr%Creset" '
alias glp="git log --format='%Cgreen%h%Creset %C(yellow)%s%Creset %C(red)(%ae)%Creset' --no-merges "
alias gpa='git push origin master-armstrong'
alias gpm='git push origin master'
alias gpr='git push origin release'
alias grv='git remote -v'
alias galias='git config --get-regexp alias'

# Other aliases
alias tmux="TERM=screen-256color-bce tmux"

alias sb='source ~/.bashrc'
alias sa='source ~/.bash_aliases'

alias dot="pset r b g y;cd ~/projects/dotfiles;git pull"

alias blog="pset r y g;cd ~/projects/blog/khanduri.github.io/;git pull"
alias myos="pset r y g;cd ~/projects/opensource/"
alias yeoman="pset r y g;cd ~/projects/yeoman/"

######################################
# Affirm settings
alias devup='cd ~/projects/affirm/all-the-things/;gc develop; git pull;'
alias masup='cd ~/projects/affirm/all-the-things/;gc master; git pull;'

######################################
# Jawbone settings
#
# alias siteops='deactivate;pset y c y;cd ~/projects/jawbone/siteops;git pull'
# alias cdjaw='deactivate;pset y c y;cd ~/projects/jawbone/srv;source tools/virtualenv/srv-env/bin/activate'
# alias cdjap='deactivate;pset y c g;cd ~/projects/jawbone/pkhanduri_srv;source tools/virtualenv/srv-env/bin/activate'
# alias upgel='./scripts/upgrade-schema -c config_pkhanduri;./update-packages.sh -d'
# alias upsrv='gc master-armstrong; git pull;gc master; git pull; gc release;git pull'

# alias gupmaster='cdjap;git fetch upstream; git checkout master; git rebase upstream/master master; git push origin master'
# alias gupma='cdjap;git fetch upstream; git checkout master-armstrong; git rebase upstream/master-armstrong master-armstrong; git push origin master-armstrong'
# alias dz='psql -h wearhaus.c0s0yd7udzgh.us-east-1.redshift.amazonaws.com -p 5439 datazoo -U pkhanduri'

# alias cdsolr='cd /usr/local/Cellar/solr/4.7.2/libexec/example/'
# alias startsolr='java -DzkRun -DnumShards=1 -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=myconf -jar start.jar'
