# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="chiggins"

plugins=(archlinux docker gem git kitchen python rails rake ruby tmux)

export EDITOR="vim"
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

source $ZSH/oh-my-zsh.sh

# Specific customizations
if [ -f $HOME/.rvm/scripts/rvm ]; then
    source $HOME/.rvm/scripts/rvm
    export PATH="$PATH:$HOME/.rvm/bin"
fi

if [ -d $HOME/metasploit-framework/ ]; then
    export PATH=$PATH:$HOME/metasploit-framework/:$HOME/metasploit-framework/tools/
    alias msfconsole="pushd $HOME/metasploit-framework/ && ./msfconsole && popd"
    alias msfwin='pushd $HOME/metasploit-framework/ && ./msfconsole -x "use multi/handler; set payload windows/meterpreter/reverse_tcp; set lhost 0.0.0.0; set lport 4444; set exitonsession false; run -j" && popd'
fi

export PYTHONSTARTUP=$HOME/.pythonrc
