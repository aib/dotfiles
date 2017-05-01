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
set matchtime=1

set noswapfile

set tabstop=4
set shiftwidth=4

" Enable mouse
set mouse=a
" and still use Ctrl-Shift-C to copy to system clipboard
vnoremap <C-S-c> "+y

try
	colorscheme default
catch
endtry

syntax on

" Set conceal for text with a replacement char
set conceallevel=2

" User-defined commands

" F2 to execute current file
nnoremap <F2> :!%:p<CR>
" Shift-F2 to execute "./run current_file"
nnoremap <S-F2> :!./run %:p<CR>

" :W as alias for :w
command W w

" :Wroot for sudo save
command Wroot w !sudo tee % > /dev/null

" :Y and :R for yanking from shell commands
command -nargs=+ -complete=shellcmd Y :let @" = system("<args>")
command -nargs=+ -complete=shellcmd R :let @" = substitute(system("<args>"), "\n$", "", "")

" Highlights
autocmd Syntax * syntax match genTrailingWhitespace /\s\+\%#\@!$/
highlight genTrailingWhitespace term=standout ctermbg=darkred guibg=darkred

autocmd Syntax * syntax match genSpaceBeforeTab /^ \+\ze\t/
highlight genSpaceBeforeTab term=standout ctermbg=darkred guibg=darkred
