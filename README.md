Need to install:

- `stow`
- `tmux`
- `zsh`
- `git`
- `neovim`
- `fzf`
- `lazygit`

Use the `stow` command to enable configuration files.

```bash
brew install font-jetbrains-mono-nerd-font zsh tmux neovim fzf lazygit
apt install zsh tmux stow neovim fzf lazygit

# Taken from lazygit docs
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# https://github.com/officialrajdeepsingh/nerd-fonts-installer

curl -fsSL https://pyenv.run | bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/NvChad/starter ~/.config/nvim
stow tmux zsh git
stow vim --adopt

# In tmux, Ctrl A + I 
```
