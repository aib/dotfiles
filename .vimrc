set nocompatible

set history=1024

" Show the command typed so far
set showcmd
" Autocompletion menu
set wildmenu

" Scroll when _near_ the top/bottom line
set scrolloff=4

" Do case insensitive searches
set ignorecase
" ...except when an uppercase letter is typed
set smartcase
" Scroll to current search matches
set incsearch

" Show matching brackets
set showmatch
" ...for a brief moment
set mat=1

set noswapfile

set tabstop=4
set shiftwidth=4

" :W for sudo save
command W w !sudo tee % > /dev/null

" Use system clipboard
set clipboard^=unnamedplus

try
	colorscheme default
catch
endtry
