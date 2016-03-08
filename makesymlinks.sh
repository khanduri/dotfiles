#!/bin/bash
#############################
# This script creates symlinks form my dotfile projects in ~/projects/dotfiles
#
# Inspired by:
#     https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
#
#############################

# VARIABLES
source_dir=~/projects/dotfiles
backup_dir=~/dotfiles_old
files='tmux.remote tmux.dev tmux.blog tmux.conf screenrc vimrc bashrc bash_profile bash_aliases snippets.json'

# BACKUP OLD DOTFiles
echo -n 'Creating $backup_dir for saving a backup of existing dotfiles'
mkdir -p $backup_dir
echo 'Done!'

echo -n 'Changing to $source_dir dir ....'
cd $source_dir
echo 'Done!'

for file in $files; do
    echo 'Moving existing $file from ~ to $backup_dir'
    mv ~/.$file $backup_dir
    echo 'Creating symlink to $file in home directory'
    ln -s $source_dir/$file ~/.$file
done

