# Config personal para Codespaces

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# fzf/ripgrep defaults
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Aliases generales
alias vim='nvim'
alias vi='nvim'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias lg='lazygit'

# Dev helpers
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me && echo'
alias serve='python3 -m http.server'
alias nvim-clean='rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim'

# Prompt simple, útil en terminal remota
if [ -n "$BASH_VERSION" ]; then
  parse_git_branch() {
    git branch --show-current 2>/dev/null | sed 's/^/ (/;s/$/)/'
  }
  export PS1='\u@\h:\w$(parse_git_branch)\$ '
fi

# Health/status check del entorno
alias check='klk-check'
alias klk='klk-check'

# Docker helpers
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
