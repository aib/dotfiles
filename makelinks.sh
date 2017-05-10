#!/bin/bash

BINDIR="${HOME}/bin"

ln -t "${HOME}" -s -r .gdbinit .gitconfig .inputrc .vim .vimrc .zshrc

if [[ ! -e "${BINDIR}" ]]; then
	mkdir "${BINDIR}"
fi

if [[ -d "${BINDIR}" ]]; then
	ln -t "${BINDIR}" -s -r bin/*
fi
