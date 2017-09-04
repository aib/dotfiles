#history
HISTFILE=~/.histfile
HISTSIZE=16384
SAVEHIST=16384

# The following lines were added by compinstall
zstyle :compinstall filename '/home/aib/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#completion
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=1

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER --forest -o pid,%cpu,%mem,tty,bsdtime,cmd'

#prompt
export PS1C='%B%F{black}%D{%H:%M:%S}%f%b %? %B%F{red}%n%f%b@%B%F{green}%m%f%b:%B%F{blue}%~%f%b%# '
export PS1NC='%D{%H:%M:%S} %? %n@%m:%~%# '
export PS1=$PS1NC

#env
export EDITOR='vi'
export VISUAL='vi'

#env options
export LESS='-Ri'
export MINICOM='--color=on'

#zsh env
REPORTTIME=20
DIRSTACKSIZE=16

#zsh options
bindkey -v

setopt extendedglob

setopt autopushd
unsetopt autocd
unsetopt beep
unsetopt notify

setopt extendedhistory
setopt histignoredups
setopt histignorespace
setopt histreduceblanks
#setopt incappendhistorytime
setopt sharehistory

#history search
bindkey '^R' history-beginning-search-backward
bindkey '^F' history-beginning-search-forward

#emacs bindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

#shift-enter same as enter
bindkey '^[OM' accept-line

#path
typeset -U path
path=($path ~/bin ~/.local/bin)

[[ -r ~/.aliases ]] && . ~/.aliases

[[ -r /etc/zsh_command_not_found ]] && . /etc/zsh_command_not_found

#startup
fortune -a | cowsay -n -TUU
