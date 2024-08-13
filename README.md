Need to install:

- `stow`
- `tmux`
- `zsh`
- `git`
- `neovim`

Use the `stow` command to enable configuration files.

```bash
brew install font-jetbrains-mono-nerd-font
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow tmux zsh git

# before you run `stow vim --adopt`
git clone https://github.com/NvChad/starter ~/.config/nvim
```
