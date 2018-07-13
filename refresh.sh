#!/bin/bash

# ZSH
wget https://github.com/Chiggins/Dotfiles/raw/master/general/zshrc -O ~/.zshrc
wget https://github.com/Chiggins/DotFiles/raw/master/general/chiggins.zsh-theme -O ~/.oh-my-zsh/themes/chiggins.zsh-theme

# VIM
wget -q https://github.com/Chiggins/DotFiles/raw/master/general/vimrc -O ~/.vimrc
vim +PluginInstall +qall

# TMUX
wget -q https://raw.githubusercontent.com/Chiggins/DotFiles/master/general/.tmux.conf -O ~/.tmux.conf

# Other customizations
wget https://github.com/Chiggins/Dotfiles/raw/master/general/gdbinit -O ~/.gdbinit
wget https://github.com/Chiggins/Dotfiles/raw/master/general/gitconfig -O ~/.gitconfig
wget https://github.com/Chiggins/Dotfiles/raw/master/general/pythonrc -O ~/.pythonrc
