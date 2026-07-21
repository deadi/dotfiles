eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export PGHOST="/var/run/postgresql"

# PATH array
typeset -U path
path=(
  $HOME/.local/share/omarchy/bin
  $HOME/.local/bin
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  $HOME/.config/mise/shims
  /usr/local/go/bin
  $path
)
export PATH


#completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

eval "$(fzf --zsh)"

#history improvements
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# TMUX
new_tmux () {
  local session_dir session_name notification

  # Pick directory via zoxide + fzf
  session_dir=$(zoxide query -l | fzf --height 40% --reverse --prompt="tmux dir> ") || return 1
  [[ -z "$session_dir" ]] && return 1
  session_dir="${session_dir%/}"

  session_name=$(basename "$session_dir")

  # If session exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
    notification="tmux attached to $session_name"

  # If session does not exist
  else
    if [[ -n "$TMUX" ]]; then
      tmux new-session -d -c "$session_dir" -s "$session_name" \
        && tmux switch-client -t "$session_name"
      notification="new tmux session INSIDE TMUX: $session_name"
    else
      tmux new-session -c "$session_dir" -s "$session_name"
      notification="new tmux session: $session_name"
    fi
  fi

  # Notification (optional)
  if command -v notify-send >/dev/null 2>&1 && [[ -n "$notification" ]]; then
    notify-send "$notification"
  fi
}

alias tm=new_tmux
alias c='z'
alias j='z'
alias zz='zi'

# --- Aliases (shared) ---
[[ -f $HOME/.aliases ]] && source $HOME/.aliases

