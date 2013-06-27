# INSTRUCTIONS:

## Dotfile setup:

```bash
mkdir -p ~/projects
git clone ssh://git@github.com/khanduri/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
./makesymlinks.sh
```

## Vim Setup:

```bash
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim
:BundleInstall
```

### Troubleshooting

##### Vim support for ruby and python
- Linux: apt-get install vim-nox
- Mac: brew install vim

##### Command-T
- ruby extconf.rb
- make


### General Queries:

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
