# The following lines were added by compinstall
zstyle :compinstall filename '/home/aib/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

## Completion ##
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER --forest -o pid,%cpu,%mem,tty,bsdtime,cmd'

#Ubuntu command-not-found
[[ -r /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

## zsh Options ##
REPORTTIME=20
DIRSTACKSIZE=16

setopt extendedglob
setopt interactivecomments

setopt autopushd
unsetopt autocd
unsetopt beep
unsetopt notify

## History ##
HISTFILE=~/.histfile
HISTSIZE=1048576
SAVEHIST=1048576

setopt extendedhistory
setopt histignoredups
setopt histignorespace
setopt histreduceblanks
#setopt incappendhistorytime
setopt sharehistory

## Key Bindings ##
bindkey -e # emacs mode
bindkey '^[' vi-cmd-mode

bindkey '^[k' up-line-or-history
bindkey '^[j' down-line-or-history

bindkey '^P' push-input

# Better history search
bindkey '^R' history-beginning-search-backward
bindkey '^F' history-beginning-search-forward
bindkey '^Xr' history-incremental-search-backward
bindkey '^Xf' history-incremental-search-forward

# Edit with editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Shift-enter same as enter
bindkey '^[OM' accept-line


#prompt
export PS1C='%B%F{black}%D{%H:%M:%S}%f%b %? %B%F{red}%n%f%b@%B%F{green}%m%f%b:%B%F{blue}%~%f%b%# '
export PS1NC='%D{%H:%M:%S} %? %n@%m:%~%# '
export PS1=$PS1C

#path
typeset -U path
path=(~/bin ~/.local/bin $path)

## Common Files ##
[[ -r ~/.environment ]] && . ~/.environment
[[ -r ~/.aliases ]] && . ~/.aliases

## Allow SSH_AUTH_SOCK override, useful when ssh-agent dies
[[ -e ~/.ssh/auth.sock ]] && export SSH_AUTH_SOCK=~/.ssh/auth.sock

## Startup ##
xtitle "$USER@$HOST"

if [[ -n "$SHELL_INIT" ]]; then
	eval "$SHELL_INIT"
	export SHELL_INIT_="$SHELL_INIT"
	unset SHELL_INIT
else
	#fortune -a | cowsay -n -TUU
fi
