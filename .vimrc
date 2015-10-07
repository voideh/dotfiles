autocmd!
execute pathogen#infect()
call pathogen#helptags()
"""""""""""""""""""""""""""
"" Basic Settings
""""""""""""""""""""""""""""
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
syntax on " syntax highlighting
set relativenumber "show line numbers
set nocompatible "remove vi compatibility
set hidden " allow saving and stuff of hidden buffers
set history=10000 " remember more commands
set expandtab  " use spaces not tab characters
set tabstop=2 " indent to 4 spaces
set shiftwidth=2 
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" Smart case sensitive searches
set magic
set ignorecase smartcase
" Highlight current cursor line
set cursorline
" cursor line settings
set cmdheight=1
set switchbuf=useopen
set showtabline=2
set winwidth=80
set nobackup
" backspacing in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
filetype plugin indent on
" wildmode settings
set wildmode=list:longest,full
set wildmenu
" mode lineszz
set modeline
set modelines=3
" no folding
set foldmethod=manual
set nofoldenable
" one sapce when joinging lines
set nojoinspaces
" automatically reload files
set autoread
" some niceities for non-programming text editing
set wrap
set linebreak
set nolist
""""""""""""""""""""""""
"" Color
""""""""""""""""""""""""
set t_Co=256 
set background=dark
colorscheme bluefeels
"""""""""""""""""""""
"" Status Line
"""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
""""""""""""""""""""""""""
"" Bindings
""""""""""""""""""""""""""
" Move around splits with ctrl+whatever
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" insert mode madness
imap <c-e> <c-o>$
imap <c-a> <c-o>^
imap <C-c> <esc>
" fuck you vim
" :W is not an editor command
" that's bullshit and you know it
command! W w
command! WQ wq
command! Wq wq
command! Q q
" SEARCH CLEARING
map <C-l> :nohl<cr>
noremap Q <nop>
"""""""""""""""""""""""""
"" Stolen functions from
"" Gary Bernhardt 
"""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
      return "\<tab>"
  else
      return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
let g:Tex_ViewRule_pdf='evince 2>/dev/null'
let g:vimtex_view_general_viewer = 'evince'
let g:vimtex_latexmk_options = '-pdf'
