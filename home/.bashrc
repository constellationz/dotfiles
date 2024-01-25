# Dotfiles can either be in ~/.rep or ~/Repositories
if [[ -x "$HOME/.rep/dotfiles" ]]; then 
	DOTS="$HOME/.rep/dotfiles"
fi
if [[ -x "$HOME/Repositories/dotfiles" ]]; then
	DOTS="$HOME/Repositories/dotfiles"
fi

# Add paths
PATH=$PATH:/usr/sbin
PATH=$PATH:~/.local/bin
PATH=$PATH:$DOTS/bin

# Don't show warning on MacOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# If not running interactively, don't set aliases
[[ $- != *i* ]] && return

# Colors and bold colors
RESET="\[\e[0m\]"
GREEN="\[\e[0;32m\]"
BLUE="\[\e[0;34m\]"
RED="\[\e[0;31m\]"
YELLOW="\[\e[0;33m\]"
BGREEN="\[\e[1;32m\]"
BBLUE="\[\e[1;34m\]"
BRED="\[\e[1;31m\]"
BYELLOW="\[\e[1;33m\]"
SYMBOL="$"

# Choose name color for different operating systems
USERCOLOR="$BGREEN"
DIRCOLOR="$GREEN"
if [ "$OSTYPE" = "darwin22" ]; then
	USERCOLOR="$BBLUE"
	DIRCOLOR="$BLUE"
fi
if [ "$EUID" = "0" ]; then
	USERCOLOR=""
	DIRCOLOR=""
	SYMBOL="#"
fi

# Custom prompt
PROMPT_COMMAND=__prompt_command
__prompt_command() {
	local EXIT="$?"
	if [ $EXIT != 0 ]; then
		PS1="${BRED}[$EXIT] "
	else
		PS1=""
	fi
	PS1+="${USERCOLOR}\u${RESET}@\h:${DIRCOLOR}\w${RESET}$SYMBOL "
}

# Type directory names to navigate
shopt -s autocd

# Set open alias if available
if command -v xdg-open &>/dev/null; then
	alias o="xdg-open"
elif command -v open &>/dev/null; then
	alias o="open"
fi

# Set git aliases if available
if command -v git &>/dev/null; then
  alias gs="git status"
  alias gc="git commit"
  alias ga="git add"
  alias gp="git push"
  alias gd="git diff"
fi

# Navigate upwards 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Add static aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias pls='!!'
alias rm='rm -i'
alias oh='o .'
alias dotfiles='cd $DOTS' 
alias dots='dotfiles' 
alias rep='cd ~/.rep'
alias desk='cd ~/Desktop/'
alias down='cd ~/Downloads/'

# Set terminal editor if available
# e - (e)dit
alias e="o"
if command -v nvim &>/dev/null; then
	alias e="nvim"
	alias vi="nvim"
	alias vim="nvim"
elif command -v micro &>/dev/null; then
	alias e="micro"
fi

# Wayland clipboard pipes to wl-copy
# c - (c)opy
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	alias c='wl-copy'
	alias imv='imv-wayland'
fi

# Use rust environment
if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
fi

# Haskell environment
if [ -f "/home/tyler/.ghcup/env" ]; then 
	source "/home/tyler/.ghcup/env"
fi
