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
alias ls='ls --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias gs='git status'
alias gd='git diff'
alias herdr='herdr-app'

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

  # 補完の見た目と挙動（readline）
  bind 'set completion-ignore-case on'        # 大文字小文字を区別しない補完
  bind 'set colored-stats on'                 # 補完候補の種類を色分け
  bind 'set colored-completion-prefix on'     # 補完で一致する部分を色付け
  bind 'set mark-symlinked-directories on'    # シンボリックリンクに / を付ける
  bind 'set visible-stats on'                 # ls -F のような記号を補完候補に表示

  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi

  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
  fi

  # mise: 言語ランタイムや開発ツールのバージョンをまとめて管理するツール（node, python など）
  if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi

  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  fi

elif [ -n "$ZSH_VERSION" ]; then
  # zsh 固有の設定
  setopt HIST_IGNORE_ALL_DUPS  # 過去に同じコマンドがあれば古い方を削除
  setopt HIST_REDUCE_BLANKS    # 余分な空白を詰めて記録
  setopt HIST_FIND_NO_DUPS        # 履歴検索で重複を表示しない
  setopt HIST_EXPIRE_DUPS_FIRST   # 容量超過時は重複を先に削除
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

  # 補完（compinit の後に置く）
  zstyle ':completion:*' menu select                    # 候補を矢印キーで選択
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # 小文字入力で大文字も補完
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # 補完候補を色付け

  if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
  fi

  # mise: 言語ランタイムや開発ツールのバージョンをまとめて管理するツール（node, python など）
  if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
  fi

  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
  fi
fi

if [ -f "$HOME/.dotfiles/local.sh" ]; then
  . "$HOME/.dotfiles/local.sh"
fi
