# ~/.dotfiles/common.sh

# --- 共通の環境変数 ---
export EDITOR="vim"
export HISTSIZE=10000

# PATHの重複を防ぎつつ先頭に追加する関数
prepend_path() {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) ;;
      *) export PATH="$1:$PATH" ;;
    esac
  fi
}

prepend_path "$HOME/.local/bin"

# --- 共通のエイリアス ---
alias ..='cd ..'
alias ll='ls -la'
alias la='ls -A'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias gs='git status'
alias gd='git diff'

# --- シェルごとの分岐 ---
if [ -n "$BASH_VERSION" ]; then
  # bash 固有の設定
  export HISTCONTROL=ignoreboth:erasedups
  shopt -s histappend
  HISTFILESIZE=20000
  alias reload='source ~/.bashrc'
  bind '"\e[A": history-search-backward' 2>/dev/null  # ↑ キー
  bind '"\e[B": history-search-forward'  2>/dev/null  # ↓ キー

  # Tab で候補を順に挿入（zsh と同じ動き）、Shift+Tab で逆順
  bind '"\t": menu-complete' 2>/dev/null
  bind '"\e[Z": menu-complete-backward' 2>/dev/null
  bind 'set show-all-if-ambiguous on' 2>/dev/null

  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi

  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
  fi

  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  fi

elif [ -n "$ZSH_VERSION" ]; then
  # zsh 固有の設定
  setopt HIST_IGNORE_ALL_DUPS  # 過去に同じコマンドがあれば古い方を削除
  setopt HIST_REDUCE_BLANKS    # 余分な空白を詰めて記録
  setopt SHARE_HISTORY
  SAVEHIST=20000
  alias reload='source ~/.zshrc'
  autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "^[[A" up-line-or-beginning-search    # ↑ キー
  bindkey "^[[B" down-line-or-beginning-search  # ↓ キー

  autoload -Uz compinit
  compinit

  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
  fi

  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi
fi

if [ -f "$HOME/.dotfiles/local.sh" ]; then
  . "$HOME/.dotfiles/local.sh"
fi
