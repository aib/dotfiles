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
zstyle ':completion:*:kill:*' command 'ps -u $USER --forest -o pid,%cpu,tty,cputime,cmd'

#env
export PS1='%* %? %n@%m:%~%# '
export EDITOR='vi'
export VISUAL='vi'

#env options
export LESS='-R'

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
#setopt appendhistory
setopt histignoredups
setopt histignorespace
setopt histreduceblanks
setopt incappendhistory
setopt sharehistory

#history search
bindkey '^R' up-line-or-search
#bindkey '^[OA' up-line-or-search
#bindkey '^[OB' down-line-or-search

. /etc/zsh_command_not_found

#path
typeset -U path
path=($path ~/bin)

#default option aliases
alias ls='ls --color=auto -F'
alias grep='grep --color=auto'

#command aliases
alias cgrep='grep --color=always'
alias hl='history -iDd 0'
alias hlg='hl | grep'
alias psl='ps -efH'
alias pslg='psl | grep'

alias sshu='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

#Initialize a git repository
gitinit() {
	if [ -n "$1" ]; then mkdir -p "$1"; cd "$1"; fi
	if git show-ref -q 2>/dev/null; [ $? -eq 128 ]; then git init .; fi
	if git show-ref -q 2>/dev/null; [ $? -eq 1 ]; then
		if [ ! -a README ]; then touch README; fi
		git add README &&
		git commit -m "Initial commit"
	; fi
}

#startup
fortune -a | cowsay -n -TUU
