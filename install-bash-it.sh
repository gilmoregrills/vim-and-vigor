# install bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
mkdir ~/.bash_it/themes/robin/

# copy themes and profiles
cp robin.theme.bash ~/.bash_it/themes/robin/
cp .bash_profile ~/.bash_profile
cp .vimrc ~/.vimrc
