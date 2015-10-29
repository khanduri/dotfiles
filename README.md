## INSTRUCTIONS:

### Dotfile setup:

```bash
mkdir -p ~/projects
git clone ssh://git@github.com/khanduri/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
./makesymlinks.sh
```

### Vim Setup:

I use [vundle](https://github.com/gmarik/Vundle.vim) as my vim package manager. Hence we'll need to get that first. 

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim
:PluginInstall
```

### Bash settings
 - [aliases](https://github.com/khanduri/dotfiles/blob/master/bash_aliases)

### Tmux config
```bash
tmux: open up tmux
ctrl-a y: Setup for staging server logins
ctrl-a u: Dev setup
```

## Troubleshooting

##### Vim support for ruby and python
- `vim --version` (make sure you see +python and +ruby in there)
- Linux: apt-get install vim-nox
- Mac: brew install vim

##### Command-T
- NOTE: mavericks runs into a problem
- `cd ~/.vim/bundle/Command-T/ruby/command-t`
- ruby extconf.rb
- make

##### CTags
https://gist.github.com/nazgob/1570678
```bash
# you have ctags but it does not work...
$ ctags -R --exclude=.git --exclude=log *
ctags: illegal option -- R
usage: ctags [-BFadtuwvx] [-f tagsfile] file ...

# you need to get new ctags, i recommend homebrew but anything will work
$ brew install ctags

#alias ctags if you used homebrew
$ alias ctags="`brew --prefix`/bin/ctags"

#try again!
ctags -R --exclude=.git --exclude=log *

# puts tags file into you .gitignore (probably global) and you're all set!
# PS. i was inspired to install ctags by https://workshops.thoughtbot.com/vim video by @r00k, thanks man!
```

## General Queries:

##### Online Markup edit tool
- http://georgeosddev.github.io/markdown-edit/


##### Figuring out distribution of unix
```bash
~$cat /etc/*-release

DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.2 LTS"
NAME="Ubuntu"
VERSION="12.04.2 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.2 LTS)"
VERSION_ID="12.04"
```
