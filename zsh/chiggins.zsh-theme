# chiggins.zsh-theme

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo "±" && return
  echo '○'
}

function rvm_env {
    if [ -f ~/.rvm/bin/rvm-prompt ]; then
        echo " %{$FG[239]%}using %{$FG[243]%}${ruby_env}%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
    fi
}

local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local prompt_char='$(prompt_char)'

PROMPT="╭─%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$HOST%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info}$(rvm_env)
╰─${prompt_char}%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
