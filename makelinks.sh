#!/bin/bash

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

autolink .aliases .bash_aliases .environment .gdbinit .gitconfig .inputrc .pylintrc .pypirc .screenrc .vimrc .XCompose .zshrc

autolink_dir bin .config .local .q3a .ssh .vim
