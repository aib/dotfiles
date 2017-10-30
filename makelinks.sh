#!/bin/bash

BINDIR="${HOME}/bin"

makelink() {
	target_dir=$1
	shift
	ln -t "${target_dir}" -s -r "$@"
}

autolink() {
	while [ -n "$1" ]; do
		dirname="${HOME}/$(dirname "$1")"
		mkdir -p "$dirname"
		makelink "$dirname" "$1"
		shift
	done
}

makelink "${HOME}" .aliases .bash_aliases .environment .gdbinit .gitconfig .inputrc .screenrc .vim .vimrc .XCompose .zshrc

if [[ ! -e "${BINDIR}" ]]; then
	mkdir "${BINDIR}"
fi

if [[ -d "${BINDIR}" ]]; then
	makelink "${BINDIR}" bin/*
fi
