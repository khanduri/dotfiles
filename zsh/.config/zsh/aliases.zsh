# This file can also be sourced on its own.
alias c='clear'
alias l='ls -alF'
alias ll='ls -alF'
alias la='ls -A'
b64e() { print -rn -- "$1" | base64; }
b64d() { print -r -- "$1" | base64 --decode; }
alias aliasf='print -l ${(ok)functions}'
if command -v git >/dev/null 2>&1; then
  alias g='git status'
  alias ga='git commit --amend --no-edit'
  alias gb='git branch'
  alias gc='git checkout'
  alias gd='git diff'
  alias ge='git commit --allow-empty -m "empty commit, trigger build"'
  alias gg='git log --oneline --abbrev-commit --all --graph --decorate --color'
  alias gm='git merge --no-commit --no-ff'
  alias gs='git show --format="%aN <%aE>"'
  alias gdc='git diff --cached'
  alias gp='git pull'
  alias gap='git add --patch'
  alias gfu='git fetch upstream'
  alias gfo='git fetch origin'
  alias glc='git log -1 --pretty=format:"%Cgreen%ci %Cred%cr%Creset"'
  alias glp="git log --format='%Cgreen%h%Creset %C(yellow)%s%Creset %C(red)(%ae)%Creset' --no-merges"
  alias grv='git remote -v'
  alias galias='git config --get-regexp alias'
fi
command -v python3 >/dev/null 2>&1 && alias prettyjson='python3 -m json.tool'
return 0
