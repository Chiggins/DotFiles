# dotfiles

Configs for zsh, tmux, neovim (NvChad) and git, linked with GNU `stow`.
Works on macOS, Debian/Ubuntu/Kali, Fedora and Arch.

```bash
git clone <this repo> ~/.dot && cd ~/.dot
./install.sh                # installs packages, pyenv, NvChad base, then stows everything
./install.sh --no-packages  # skip the package manager step
```

Zinit, tmux plugins (TPM) and zsh plugins install themselves on first launch.
Put per-machine settings (work paths, KUBECONFIG, etc.) in `~/.zshrc.local`; it is sourced last and not tracked.

On Kali, `install.sh` detects the OS and also runs `kali_setup.sh` (pentest tooling, fonts, screen-lock settings), so a single `./install.sh` sets up everything. Pass `--no-kali` to skip it.
