export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

##################################
# Git functions
##################################

# Show git info in the prompt
function parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Removed merged branches
# from http://rob.by/2013/remove-merged-branches-from-git
function rmb {
  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ "$current_branch" != "master" ]; then
    echo "WARNING: You are on branch $current_branch, NOT master."
  fi
  echo "Fetching merged branches..."
  git remote prune origin
  remote_branches=$(git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$")
  local_branches=$(git branch --merged | grep -v 'master$' | grep -v "$current_branch$")
  if [ -z "$remote_branches" ] && [ -z "$local_branches" ]; then
    echo "No existing branches have been merged into $current_branch."
  else
    echo "This will remove the following branches:"
    # if [ -n "$remote_branches" ]; then
    #   echo "$remote_branches"
    # fi
    if [ -n "$local_branches" ]; then
      echo "$local_branches"
    fi
    read -p "Continue? (y/n): " -n 1 choice
    echo
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
      # Remove remote branches
      # git push origin `git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$" | sed 's/origin\//:/g' | tr -d '\n'`
      # Remove local branches
      git branch -d `git branch --merged | grep -v 'master$' | grep -v "$current_branch$" | sed 's/origin\///g' | tr -d '\n'`
    else
      echo "No branches removed."
    fi
  fi
}

##################################
# Global exports
##################################

# export TERM="xterm-color"
export TERM=screen-256color
export FB_USER_ID=517521816
export GREP_OPTIONS='--color=auto'

export EVENT_NOKQUEUE=1
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

# AWS: elastic bean stalk
export PATH=$PATH:~/projects/bin/AWS-ElasticBeanstalk-CLI-2.6.2/eb/macosx/python2.7/

##################################
# SSH key forwarding
# http://qq.is/article/ssh-keys-through-screen
# Predictable SSH authentication socket location.
##################################

SOCK="/tmp/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ] 
then
    rm -f /tmp/ssh-agent-$USER-tmux
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

pbin() {
  DATA=$(cat)
  KEY=`curl -X POST -s -d "${DATA}" http://paste.aliph.com/documents | sed -e 's/{"key":"\(.*\)"}/\1/'`
  URL="http://paste.aliph.com/${KEY}.json"
  echo ${URL}
  open ${URL}
}

##################################
# Colors
##################################
# Normal Colors
ck='\[\e[0;30m\]'        # Black
cr='\[\e[0;31m\]'          # Red
cg='\[\e[0;32m\]'        # Green
cy='\[\e[0;33m\]'       # Yellow
cb='\[\e[0;34m\]'         # Blue
cp='\[\e[0;35m\]'       # Purple
cc='\[\e[0;36m\]'         # Cyan
cw='\[\e[0;37m\]'        # White
# Bold
cbk='\[\e[1;30m\]'       # Black
cbr='\[\e[1;31m\]'         # Red
cbg='\[\e[1;32m\]'       # Green
cby='\[\e[1;33m\]'      # Yellow
cbb='\[\e[1;34m\]'        # Blue
cbp='\[\e[1;35m\]'      # Purple
cbc='\[\e[1;36m\]'        # Cyan
cbw='\[\e[1;37m\]'       # White
# Background
ckk='\[\e[40m\]'       # Black
ckr='\[\e[41m\]'         # Red
ckg='\[\e[42m\]'       # Green
cky='\[\e[43m\]'      # Yellow
ckb='\[\e[44m\]'        # Blue
ckp='\[\e[45m\]'      # Purple
ckc='\[\e[46m\]'        # Cyan
ckw='\[\e[47m\]'       # White

NC="\[\e[m\]"               # Color Reset
ED="\[\e[m\]"

##################################
# Prompt
##################################

pset() {
    c1=c$1;c2=c$2;c3=c$3;c4=c$4
    PS1="[\D{%F %T %Z}]${!c1}\u$ED@${!c2}\h$ED:${!c3}\w$ED${!c4}\$(parse_git_branch)$ED\$" 
}

# For an unknown box
pset kr kr br br


##################################
# Config per box
##################################

if [[ `hostname` = *local* ]]; then
    alias ctags='/usr/local/bin/ctags'
    alias vim='/usr/local/Cellar/vim/7.4.712_1/bin/vim'
    
    export JAVA_HOME=$(/usr/libexec/java_home -v '1.7*')
    export JDK_HOME=$(/usr/libexec/java_home -v '1.7*')

    export PATH="$PATH:/usr/local/Cellar/ruby/2.1.1/bin/" # gem bins
    export PATH="/usr/local/Cellar/ruby/2.0.0-p195/bin:$PATH" # gem bins
    export PATH="/usr/local/sbin:$PATH" # for rabbitMQ
    export PATH="/usr/local/bin:$PATH" # for rabbitMQ

    # export PYTHONPATH=/usr/local/Cellar/opencv/2.4.7.1/lib/python2.7/site-packages/:$PYTHONPATH
    # export PATH="/usr/local/heroku/bin:$PATH" # Added by the Heroku Toolbelt
    # export DEVLOCAL=True
    # export DATABASE=SQLITE

    cd ~/projects/affirm

    # source ~/.django_bash_completion
    # source ~/projects/HearsayLabs/virtualenv/bin/activate
    pset c g r bg
fi
if [[ `hostname` = *dev.affirm* ]]; then
    pset bc y r by
fi
if [[ `hostname` = *stage.affirm* ]]; then
    pset bc r r br
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting


# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

