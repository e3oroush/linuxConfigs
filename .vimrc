" general options
set number
set guioptions=
set spell spelllang=en_us
syntax on
filetype plugin on
let mapleader=","

execute pathogen#infect()
" tab completion
set wildmode=longest,list,full
set wildmenu

" indentation settings
set tabstop=4
set shiftwidth=4
"set expandtab
set smartindent
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i

" remove annoying ex-mode feature
nnoremap Q <nop>

" restore old state of file on reload
" au BufWinLeave * mkview
"au BufWinEnter * silent loadview

" syntax highlighting
set term=xterm-256color

hi clear SpellBad
hi clear SpellLocal
hi clear SpellCap
hi clear SpellRare
hi SpellBad cterm=underline
hi SpellLocal cterm=none
hi SpellCap cterm=underline
hi SpellRare cterm=underline

hi Comment cterm=none ctermfg=103
hi Constant cterm=none ctermfg=36
hi Statement cterm=none ctermfg=green

hi VarId cterm=none ctermfg=7 "122
hi Identifier cterm=none ctermfg=7
hi Normal cterm=none ctermfg=7

hi hsType cterm=none ctermfg=130
hi hsDelimiter cterm=none ctermfg=green


" spell checking
fun! IgnoreCamelCaseSpell()
    syn match CamelCase /<[A-Z][a-z]+[A-Z].{-}>/ contains=@NoSpell transparent
    syn cluster Spell add=CamelCase
endfun
autocmd BufRead,BufNewFile * :call IgnoreCamelCaseSpell()

" add md as markdown filetype
autocmd BufNewFile,BufReadPost *.md set filetype=markdown





" automatically add bird tracks for literate programming
:set formatoptions+=ro

" remove trailing whitespaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" to remember position of opened file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" enables backspace
set backspace=indent,eol,start
"cnoremap ^_ s/^/\/\/<cr>
nnoremap <leader>nt :tabnew
nnoremap <leader>ut :UndotreeToggle<cr>

" some backup and undo config considerations
set backup
set updatecount =100
set undofile

" set backup directories
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swap//


" incsearch plugin
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
packadd! matchit"""
" saner command line history
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>
" saner Crl-l
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
" jump to header source files
autocmd BufLeave *.{c,cpp} mark C
autocmd BufLeave *.h       mark H
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif
" Don't lose selection when shifting sidewards
xnoremap <  <gv
xnoremap >  >gv
" smarter cursorLine
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
autocmd ColorScheme * highlight StatusLine ctermbg=darkgray cterm=NONE guibg=darkgray gui=NONE
autocmd ColorScheme lucius highlight StatusLine ctermbg=darkgray cterm=NONE guibg=darkgray gui=NONE
" git gutter
nnoremap <leader>gdif :GitGutterLineHighlightsToggle<cr>

" status light powerline
set noshowmode
set laststatus=2
let g:Powerline_symbols = 'powerline'
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? '⭠ '.branch : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction


