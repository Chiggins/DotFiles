# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(archlinux gem git python rails3 rake ruby)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
PATH=/home/chiggins/metasploit-framework/:/home/chiggins/metasploit-framework/tools/:/opt/android-sdk/platform-tools/:/opt/android-sdk/tools/:/home/chiggins/random-scripts:$PATH
export EDITOR="vim"
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

if test -f ~/.rvm/scripts/rvm; then
    [ "$(type rvm)" = "function" ] || source ~/.rvm/scripts/rvm
fi
