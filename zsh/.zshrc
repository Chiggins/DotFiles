# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -a --color $realpath'

# emacs binding
bindkey -e

# Aliases
alias ls='ls --color'
alias nse='ls /usr/share/nmap/scripts/ | grep'
alias vim='nvim'
alias g='git'
alias gst='g status'
alias glg='g lg'

max7z() {
    7z a -t7z $1 -m0=BCJ2 -m1=LZMA2:d=1024m -aoa $2
}

_draw_horizontal_line_separator() {
  # For a basic hyphen, use "-". For a heavier line, use "━" (U+2501).
  local line_char="─"
  local line_char=">"

  # %F{238} is a dim gray. %F{blue}, %F{red}, etc., also work.
  local line_color="%F{blue}"
  local reset_color="%f" # Resets to default color

  local line_buffer
  #line_buffer=$(printf '%*s' "${COLUMNS:-80}" '' | tr ' ' "${line_char}")
  line_buffer=$(printf '%*s' "-3" '' | tr ' ' "${line_char}")

  if [[ -n "$line_color" && "$line_color" != "%f" ]]; then
    print -rP -- "${line_color}${line_buffer}${reset_color}"
  else
    print -rP -- "${line_buffer}"
  fi
}

if (( ! ${precmd_functions[(I)_draw_horizontal_line_separator]} )); then
  precmd_functions+=(_draw_horizontal_line_separator)
fi

# PATH fun
PATH=$PATH:$HOME/.local/bin/

# bugfix https://github.com/romkatv/powerlevel10k/issues/1554
unset ZSH_AUTOSUGGEST_USE_ASYNC

# Shell integrations
eval "$(fzf --zsh)"

PATH=$(pyenv root)/shims:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/chiggins/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/chiggins/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chiggins/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/chiggins/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
