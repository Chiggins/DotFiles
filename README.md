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
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/NvChad/starter ~/.config/nvim
stow tmux zsh git
stow vim --adopt

# In tmux, Ctrl A + I 
```
