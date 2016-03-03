# /bin/bash

dir=~/dotfiles
olddir=~/dotfiles_old
files="bashrc vimrc"

# create backup directory in ~/dotfiles_old
echo "Creating $olddir for backup of any existing dotfiles in ~/"
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "done"

# move existing dotfiles in ~/ to dotfiles_old and then create symlinks

for file in $files; do
	echo "Moving existing dotfiles in ~/ to $olddir"
	mv ~/.$file ~/dotfiles_old/
	echo "Creating symlink to $file in ~/"
	ln -s $dir/$file ~/.$file
done
