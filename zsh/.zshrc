# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew (macOS Apple Silicon / Intel, Linuxbrew)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $_brew ]]; then eval "$($_brew shellenv)"; break; fi
done
unset _brew

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins (completions must be on fpath before compinit; fzf-tab after it)
zinit light zsh-users/zsh-completions

# Load completions (full rebuild at most once a day, otherwise use the cache)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting # must be last

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

# emacs binding
bindkey -e

# Aliases (BSD ls on macOS has no --color, use -G there)
if ls --color=auto / >/dev/null 2>&1; then
  alias ls='ls --color=auto'
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -a --color $realpath'
else
  alias ls='ls -G'
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -aG $realpath'
fi
alias nse='ls /usr/share/nmap/scripts/ | grep'
alias vim='nvim'
alias g='git'
alias gst='g status'
alias glg='g lg'

max7z() {
    7z a -t7z $1 -m0=BCJ2 -m1=LZMA2:d=1024m -aoa $2
}

# Print a separator line before each prompt (no subshell/fork per prompt)
_draw_horizontal_line_separator() {
  print -rP -- "%F{blue}>>>%f"
}

if (( ! ${precmd_functions[(I)_draw_horizontal_line_separator]} )); then
  precmd_functions+=(_draw_horizontal_line_separator)
fi

# PATH fun
PATH=$PATH:$HOME/.local/bin/

# bugfix https://github.com/romkatv/powerlevel10k/issues/1554
unset ZSH_AUTOSUGGEST_USE_ASYNC

# Shell integrations
(( $+commands[fzf] )) && source <(fzf --zsh)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d $PYENV_ROOT/shims ]] && export PATH="$PYENV_ROOT/shims:$PATH"

# Disable auto title for tmux
DISABLE_AUTO_TITLE="true"

# Google Cloud SDK
for _gcloud in "$HOME/Downloads/google-cloud-sdk" "$HOME/google-cloud-sdk" /opt/homebrew/share/google-cloud-sdk; do
  if [[ -f $_gcloud/path.zsh.inc ]]; then
    . "$_gcloud/path.zsh.inc"
    [[ -f $_gcloud/completion.zsh.inc ]] && . "$_gcloud/completion.zsh.inc"
    break
  fi
done
unset _gcloud

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
for _conda in /opt/homebrew/Caskroom/miniconda/base "$HOME/miniconda3" "$HOME/anaconda3"; do
  if [[ -x $_conda/bin/conda ]]; then
    __conda_setup="$("$_conda/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    elif [ -f "$_conda/etc/profile.d/conda.sh" ]; then
        . "$_conda/etc/profile.d/conda.sh"
    else
        export PATH="$_conda/bin:$PATH"
    fi
    unset __conda_setup
    break
  fi
done
unset _conda
# <<< conda initialize <<<

# Mac Customization
[[ -d /opt/homebrew/opt/curl/bin ]] && export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# AGE
[[ -f $HOME/.sops/key.txt ]] && export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt

# Kubernetes
if (( $+commands[kubectl] )); then
  [[ -f $HOME/Code/GitOpsHomelab/talos_terraform/kubeconfig.yaml ]] && \
    export KUBECONFIG="$HOME/Code/GitOpsHomelab/talos_terraform/kubeconfig.yaml"
  alias k='kubectl'
  alias kn='kubectl get namespaces'
  alias kp='kubectl get pods -o wide -A'
  source <(kubectl completion zsh)
fi

# Machine-specific overrides (work laptop, VMs, etc.) - not tracked in this repo
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
