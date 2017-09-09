#!/bin/bash

BINDIR="${HOME}/bin"

makelink() {
	target_dir=$1
	shift
	ln -t "${target_dir}" -s -r "$@"
}

makelink "${HOME}" .aliases .bash_aliases .gdbinit .gitconfig .inputrc .screenrc .vim .vimrc .zshrc

if [[ ! -e "${BINDIR}" ]]; then
	mkdir "${BINDIR}"
fi

if [[ -d "${BINDIR}" ]]; then
	makelink "${BINDIR}" bin/*
fi
