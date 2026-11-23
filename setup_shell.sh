#!/bin/sh
# ===== 使い方 =====
# chmod +x ~/.dotfiles/setup_shell.sh
# ~/.dotfiles/setup_shell.sh              # バックアップあり（デフォルト）
# ~/.dotfiles/setup_shell.sh --no-backup  # バックアップなしでリンク作成
# ~/.dotfiles/setup_shell.sh --backup     # バックアップありを明示

set -e

DOTFILES_DIR="$HOME/.dotfiles"
DO_BACKUP=1

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-backup)
      DO_BACKUP=0
      ;;
    --backup)
      DO_BACKUP=1
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--backup | --no-backup]" >&2
      exit 1
      ;;
  esac
  shift
done

link_file() {
  src="$1"
  dst="$2"

  if [ ! -e "$src" ]; then
    echo "Warning: Source file not found: $src (skipped)"
    return 1
  fi

  dst_dir=$(dirname "$dst")
  mkdir -p "$dst_dir"

  # すでに実体ファイル・ディレクトリが存在する場合
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ "$DO_BACKUP" -eq 1 ]; then
      echo "Backing up $dst to ${dst}.bak"
      mv "$dst" "${dst}.bak"
    else
      echo "Skipping backup for $dst (--no-backup)"
    fi
  fi

  # 既存のリンクや実体を消して新しいリンクを作成
  rm -rf "$dst"
  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

link_file "$DOTFILES_DIR/bashrc"        "$HOME/.bashrc"
link_file "$DOTFILES_DIR/zshrc"         "$HOME/.zshrc"
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

echo "Setup completed!"