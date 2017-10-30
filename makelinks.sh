#!/bin/bash

BINDIR="${HOME}/bin"

makelink() {
	target_dir=$1
	shift
	ln -t "${target_dir}" -s -r -v "$@"
}

autolink() {
	while [ -n "$1" ]; do
		dirname="${HOME}/$(dirname "$1")"
		mkdir -p "$dirname"
		makelink "$dirname" "$1"
		shift
	done
}

autolink_dir() {
	while [ -n "$1" ]; do
		find "$1" -type f -print0 | while read -r -d '' file; do
			autolink "$file"
		done
		shift
	done
}

makelink "${HOME}" .aliases .bash_aliases .environment .gdbinit .gitconfig .inputrc .screenrc .vim .vimrc .XCompose .zshrc

autolink .local/share/qalculate/definitions/variables.xml

if [[ ! -e "${BINDIR}" ]]; then
	mkdir "${BINDIR}"
fi

if [[ -d "${BINDIR}" ]]; then
	makelink "${BINDIR}" bin/*
fi
