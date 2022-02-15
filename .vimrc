set nocompatible

set history=1024

" Show the command typed so far
set showcmd
" Autocompletion menu
set wildmenu

" Scroll when _near_ the top/bottom line
set scrolloff=4
" and near the left/right side
set sidescrolloff=8

" Do case insensitive searches
set ignorecase
" ...except when an uppercase letter is typed
set smartcase
" Scroll to current search matches
set incsearch

" Show matching brackets
set showmatch
" ...for a brief moment
set matchtime=1

set noswapfile

set tabstop=4
set shiftwidth=4

set autoindent
set smartindent
set copyindent

" No octal with ^A/^X
set nrformats-=octal

if has('autocmd')
	" Do not auto-wrap comments, do not continue on next line (WTF?!)
	autocmd BufEnter * setlocal formatoptions-=cro
endif

" Enable mouse
if has('mouse')
	set mouse=a
endif

" Use the X (middle-click) clipboard ("*) as the default register
" I do not use the system clipboard ("+) because I keep its history and vim tends to change it a lot
set clipboard=unnamed

" Ctrl-C for copy is useful when you're in the GUI mindset and using vim as a scratch pad
vnoremap <C-c> "+y

" Enable syntax highlighting
if has('syntax')
	syntax on
endif

" Set conceal for text with a replacement char
set conceallevel=2

" User-defined commands

" F2 to execute makeprg
nnoremap <F2> :make!<CR>
" Shift-F2 to execute the current file
nnoremap <S-F2> :!%:p<CR>

nnoremap <F3> :!git gui<CR>

if has('user_commands')
	" :W as alias for :w
	command W w

	" :Wroot for sudo save
	command Wroot w !sudo tee % > /dev/null

	" :Y and :R for yanking from shell commands
	if has('clipboard')
		command -nargs=+ -complete=shellcmd R :let @* = system("<args>")
		command -nargs=+ -complete=shellcmd Y :let @* = substitute(system("<args>"), "\n$", "", "")
	else
		command -nargs=+ -complete=shellcmd R :let @" = system("<args>")
		command -nargs=+ -complete=shellcmd Y :let @" = substitute(system("<args>"), "\n$", "", "")
	endif

	command -range=% StripTS let tmp_view = winsaveview() | keeppatterns <line1>,<line2>s/\s*$// | call winrestview(tmp_view) | unlet tmp_view
endif

" Highlights
if has('autocmd') && has('syntax')
	autocmd BufEnter * syntax match genTrailingWhitespace /\s\+\%#\@!$/ containedin=ALL
	highlight genTrailingWhitespace term=standout ctermbg=darkred guibg=darkred

	autocmd BufEnter * syntax match genSpaceBeforeTab /^ \+\ze\t/ containedin=ALL
	highlight genSpaceBeforeTab term=standout ctermbg=darkred guibg=darkred

	autocmd BufEnter * syntax match genNonAscii /[^\t\x20-\x7e]/ containedin=ALL
	highlight genNonAscii term=standout ctermbg=darkblue guibg=darkblue
endif

" vim-plugged
silent! if plug#begin('~/.vim/plugged')
	Plug 'mbbill/undotree'
	Plug 'tpope/vim-sleuth'
	Plug 'tpope/vim-unimpaired'

	call plug#end()
endif

" Default plugin settings
silent! let g:netrw_dirhistmax = 0
silent! let g:python_recommended_style = 0
