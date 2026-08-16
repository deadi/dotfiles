# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

if [[ -n "$OMARCHY_PATH" && -r "$OMARCHY_PATH/default/bash/rc" ]]; then
    # All the default Omarchy aliases and functions
    # (don't mess with these directly, just overwrite them here!)
    source "$OMARCHY_PATH/default/bash/rc"
else
    # Non-Omarchy fallback (e.g. Ubuntu server): generic Debian/Ubuntu defaults

    # don't put duplicate lines or lines starting with space in the history.
    HISTCONTROL=ignoreboth

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi
fi

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# Shared local aliases
[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"

# Prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# fzf keybindings and completion
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

# Directory jumping
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

# Clear screen and show system info on shell start
clear
command -v neofetch >/dev/null 2>&1 && neofetch

# Local bin path (needed for Obsidian CLI)
export PATH="$PATH:$HOME/.local/bin"

# Cargo env (adds ~/.cargo/bin to PATH)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
