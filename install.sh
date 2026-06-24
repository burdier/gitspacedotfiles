#!/usr/bin/env bash
set -Eeuo pipefail

# Dotfiles para GitHub Codespaces + AstroNvim
# Este script es ejecutado automáticamente por Codespaces si el repo está activado como dotfiles.

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
NVIM_DIR="$HOME/.config/nvim"

log()  { printf '\n[dotfiles] %s\n' "$*"; }
warn() { printf '\n[dotfiles][WARN] %s\n' "$*" >&2; }

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT" "$HOME/.config"

append_once() {
  local file="$1"
  local marker="$2"
  local content="$3"
  touch "$file"
  if ! grep -Fq "$marker" "$file"; then
    printf '\n%s\n%s\n' "$marker" "$content" >> "$file"
  fi
}

version_ge() {
  # version_ge 0.11.0 0.10.0 => true
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

install_apt_packages() {
  if ! command -v apt-get >/dev/null 2>&1; then
    warn "apt-get no está disponible; salto instalación de paquetes base."
    return 0
  fi

  log "Instalando paquetes base útiles para Codespaces..."
  sudo apt-get update -y
  sudo apt-get install -y \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    fd-find \
    fzf \
    git \
    htop \
    jq \
    less \
    python3 \
    python3-pip \
    ripgrep \
    tar \
    tmux \
    tree \
    unzip \
    wget \
    xclip \
    zip

  # Instala node/npm si el devcontainer base no los trae.
  if ! command -v node >/dev/null 2>&1; then
    sudo apt-get install -y nodejs npm || warn "No pude instalar nodejs/npm con apt."
  fi

  # Algunos repos Ubuntu/Debian tienen lazygit/bottom; si no están, no rompemos el setup.
  sudo apt-get install -y lazygit bottom 2>/dev/null || true

  # Ubuntu/Debian instala fd como "fdfind". AstroNvim y varios plugins esperan "fd".
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
  fi
}

install_latest_neovim_if_needed() {
  local required="0.11.0"
  local current=""

  if command -v nvim >/dev/null 2>&1; then
    current="$(nvim --version | head -n1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true)"
  fi

  if [ -n "$current" ] && version_ge "$current" "$required"; then
    log "Neovim $current ya cumple con AstroNvim."
    return 0
  fi

  log "Instalando Neovim estable en ~/.local/opt/nvim porque AstroNvim v6 requiere 0.11+."

  local arch asset url tmp
  arch="$(uname -m)"
  case "$arch" in
    x86_64|amd64) asset="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) asset="nvim-linux-arm64.tar.gz" ;;
    *)
      warn "Arquitectura no soportada automáticamente: $arch. Instala Neovim 0.11+ manualmente."
      return 0
      ;;
  esac

  url="https://github.com/neovim/neovim/releases/latest/download/${asset}"
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/$asset"
  rm -rf "$LOCAL_OPT/nvim"
  mkdir -p "$LOCAL_OPT/nvim"
  tar -xzf "$tmp/$asset" --strip-components=1 -C "$LOCAL_OPT/nvim"
  ln -sf "$LOCAL_OPT/nvim/bin/nvim" "$LOCAL_BIN/nvim"
  rm -rf "$tmp"

  append_once "$HOME/.bashrc" "# >>> dotfiles PATH" 'export PATH="$HOME/.local/bin:$PATH"'
  if [ -f "$HOME/.zshrc" ]; then
    append_once "$HOME/.zshrc" "# >>> dotfiles PATH" 'export PATH="$HOME/.local/bin:$PATH"'
  fi
}

install_shell_config() {
  log "Configurando shell: EDITOR=nvim, aliases, tmux y utilidades..."
  mkdir -p "$HOME/.config/dotfiles"
  cp "$DOTFILES_DIR/shell/bashrc_extra.sh" "$HOME/.config/dotfiles/bashrc_extra.sh"
  append_once "$HOME/.bashrc" "# >>> dotfiles shell config" 'source "$HOME/.config/dotfiles/bashrc_extra.sh"'

  if [ -f "$HOME/.zshrc" ]; then
    cp "$DOTFILES_DIR/shell/zshrc_extra.sh" "$HOME/.config/dotfiles/zshrc_extra.sh"
    append_once "$HOME/.zshrc" "# >>> dotfiles zsh config" 'source "$HOME/.config/dotfiles/zshrc_extra.sh"'
  fi

  if [ -f "$DOTFILES_DIR/.tmux.conf" ]; then
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
  fi

  mkdir -p "$HOME/.local/bin"
  for f in "$DOTFILES_DIR"/bin/*; do
    [ -f "$f" ] || continue
    chmod +x "$f"
    ln -sf "$f" "$HOME/.local/bin/$(basename "$f")"
  done
}

install_git_config_sample() {
  mkdir -p "$HOME/.config/git"
  cp "$DOTFILES_DIR/git/gitconfig.sample" "$HOME/.config/git/gitconfig.sample"
  if [ ! -f "$HOME/.gitconfig" ]; then
    cp "$DOTFILES_DIR/git/gitconfig.sample" "$HOME/.gitconfig"
    warn "Creé ~/.gitconfig de ejemplo. Cambia name/email antes de commitear si hace falta."
  else
    log "Ya existe ~/.gitconfig; no lo sobrescribo. Dejé un sample en ~/.config/git/gitconfig.sample."
  fi
}

install_astronvim() {
  log "Preparando AstroNvim en ~/.config/nvim..."

  if [ ! -d "$NVIM_DIR" ]; then
    git clone --depth 1 https://github.com/AstroNvim/template "$NVIM_DIR"
    rm -rf "$NVIM_DIR/.git"
  else
    warn "Ya existe $NVIM_DIR; no lo borro. Solo aplicaré los archivos personalizados del repo."
  fi

  mkdir -p "$NVIM_DIR/lua/plugins"
  cp "$DOTFILES_DIR/astronvim/lua/community.lua" "$NVIM_DIR/lua/community.lua"
  cp "$DOTFILES_DIR/astronvim/lua/plugins/astrocore.lua" "$NVIM_DIR/lua/plugins/astrocore.lua"
  cp "$DOTFILES_DIR/astronvim/lua/plugins/astroui.lua" "$NVIM_DIR/lua/plugins/astroui.lua"

  log "AstroNvim listo. Abre con: nvim"
}

main() {
  install_apt_packages
  install_latest_neovim_if_needed
  install_shell_config
  install_git_config_sample
  install_astronvim

  log "Listo. Reinicia la terminal o ejecuta: source ~/.bashrc"
}

main "$@"
