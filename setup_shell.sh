#!/bin/sh
# ===== 使い方 =====
# chmod +x ~/.dotfiles/setup_shell.sh
# ~/.dotfiles/setup_shell.sh


DOTFILES_DIR="$HOME/.dotfiles"

# バックアップを取りつつリンクを作成する関数
link_file() {
  src="$1"
  dst="$2"

  # すでに実体ファイルが存在する場合はバックアップ
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst to ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  # 既存のリンクを削除して新しく貼る
  rm -f "$dst"
  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

link_file "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
link_file "$DOTFILES_DIR/zshrc"  "$HOME/.zshrc"

echo "Setup completed!"

