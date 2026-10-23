#!/usr/bin/env bash
# Bootstrap these dotfiles on a new machine (macOS, Debian/Ubuntu/Kali, Fedora, Arch).
# Usage: ./install.sh [--no-packages] [--no-kali]
# On Kali, kali_setup.sh (pentest tooling, fonts, etc.) runs automatically at the end.
set -euo pipefail

DOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh tmux stow git fzf curl)
INSTALL_PACKAGES=1
RUN_KALI_SETUP=1
for arg in "$@"; do
  case "$arg" in
    --no-packages) INSTALL_PACKAGES=0 ;;
    --no-kali) RUN_KALI_SETUP=0 ;;
    *) echo "Unknown option: $arg"; echo "Usage: $0 [--no-packages] [--no-kali]"; exit 1 ;;
  esac
done

say() { printf '\n=== %s ===\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

is_kali() { [[ -r /etc/os-release ]] && grep -qi '^ID=kali' /etc/os-release; }

SUDO=""
[[ $EUID -ne 0 ]] && have sudo && SUDO="sudo"

install_packages() {
  case "$(uname -s)" in
    Darwin)
      have brew || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
      brew install "${PACKAGES[@]}" neovim lazygit
      brew install --cask font-jetbrains-mono-nerd-font || true
      ;;
    Linux)
      if have apt-get; then
        $SUDO apt-get update
        $SUDO apt-get install -y "${PACKAGES[@]}"
        $SUDO apt-get install -y lazygit || install_lazygit_release
        install_neovim_from_source "$SUDO apt-get install -y cmake ninja-build gettext build-essential"
      elif have dnf; then
        $SUDO dnf install -y "${PACKAGES[@]}"
        install_lazygit_release
        install_neovim_from_source "$SUDO dnf install -y cmake ninja-build gettext gcc make"
      elif have pacman; then
        $SUDO pacman -S --needed --noconfirm "${PACKAGES[@]}" neovim lazygit
      else
        echo "Unknown package manager; install manually: ${PACKAGES[*]} lazygit"
      fi
      ;;
  esac
}

# Distro neovim packages are often too old for NvChad (needs >= 0.10), so build
# the stable branch when the installed version is missing or too old.
install_neovim_from_source() {
  local deps_cmd="$1" ver
  if have nvim; then
    ver=$(nvim --version | sed -n '1s/.*v0\.\([0-9]*\).*/\1/p')
    [[ "${ver:-0}" -ge 10 ]] && return
  fi
  say "Building neovim from source"
  $deps_cmd
  local src
  src=$(mktemp -d)
  git clone --depth 1 --branch stable https://github.com/neovim/neovim "$src"
  (cd "$src" && make CMAKE_BUILD_TYPE=RelWithDebInfo && $SUDO make install)
  rm -rf "$src"
}

install_lazygit_release() {
  have lazygit && return
  local arch ver tmp
  case "$(uname -m)" in aarch64|arm64) arch=arm64 ;; *) arch=x86_64 ;; esac
  ver=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_${arch}.tar.gz" \
    | tar xz -C "$tmp" lazygit
  $SUDO install "$tmp/lazygit" -D -t /usr/local/bin/
  rm -rf "$tmp"
}

# Move aside any real (non-symlink) file that would block stow
backup_conflicts() {
  local pkg="$1" f rel target
  while IFS= read -r -d '' f; do
    rel="${f#"$DOT_DIR/$pkg/"}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "Backing up $target -> $target.bak"
      mv "$target" "$target.bak"
    fi
  done < <(find "$DOT_DIR/$pkg" -type f -print0)
}

if [[ $INSTALL_PACKAGES -eq 1 ]]; then
  say "Installing packages"
  install_packages
fi

have stow || { echo "stow is required"; exit 1; }

say "Installing pyenv"
[[ -d "$HOME/.pyenv" ]] || curl -fsSL https://pyenv.run | bash || echo "pyenv install failed (non-fatal)"

say "Setting up NvChad base"
if [[ ! -d "$HOME/.config/nvim" ]]; then
  git clone --depth 1 https://github.com/NvChad/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
fi

say "Linking dotfiles with stow"
cd "$DOT_DIR"
# vim/ overlays files onto the NvChad starter; back up the starter's copies
# instead of using `stow --adopt`, which would overwrite the versions in this repo.
for pkg in tmux zsh git vim; do
  backup_conflicts "$pkg"
  stow --restow "$pkg"
done

say "Setting zsh as the default shell"
if [[ "${SHELL##*/}" != "zsh" ]] && have zsh; then
  $SUDO chsh -s "$(command -v zsh)" "$USER" || echo "Run manually: chsh -s $(command -v zsh)"
fi

if [[ $RUN_KALI_SETUP -eq 1 ]] && is_kali; then
  say "Kali detected: running kali_setup.sh"
  bash "$DOT_DIR/kali_setup.sh"
fi

say "Done"
echo "Open a new terminal (zinit, tmux plugins and nvim plugins install themselves on first launch)."
echo "Put machine-specific shell config in ~/.zshrc.local"
