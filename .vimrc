call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/bufexplorer.zip'
Plug 'davidhalter/jedi-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'itchyny/lightline.vim'

call plug#end()

set history=500 " Sets how many lines of history VIM has to remember
set nu " Sets number line
filetype plugin on " Enable filetype plugins
filetype indent on " Indentation    
set autoread " Set to auto read when a file is changed from the outside
au FocusGained,BufEnter * checktime
let mapleader = "," "Leader key is ,
set wildmenu " Turn on the Wild menu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set ruler "Always show current position
set cmdheight=1 " Height of the command bar
set hid " A buffer becomes hidden when it is abandoned
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases 
set hlsearch " Highlight search results
set incsearch " Makes search act like search in modern browsers
set lazyredraw  " Don't redraw while executing macros (good performance config)
set magic " For regular expressions turn magic on
set showmatch " Show matching brackets when text indicator is over them
set mat=2 " How many tenths of a second to blink when matching brackets
" No annoying sound on errors
set noerrorbells
set novisualbell
set tm=500
set foldcolumn=1 " Add a bit extra margin to the left
syntax enable  " Enable syntax highlighting
" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif
set background=dark
colorscheme palenight "gruvbox
"let g:lightline = { 'colorscheme': 'palenight' }
set laststatus=2
set noshowmode
set encoding=utf8 " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac " Use Unix as the standard file type
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile
set expandtab " Use spaces instead of tabs
set smarttab " Be smart when using tabs ;)
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" Linebreak on 500 characters
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> :source %<cr>
map <C-space> ?
map <silent> <leader><cr> :noh<cr> " Disable highlight when <leader><cr> is pressed
"map ctrl-S to save
map <C-s> :w!<cr>
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>bd :Bclose<cr>:tabclose<cr>gT " Close the current buffer
" Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr> " Move to next buffer
" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 
" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/ " Opens a new tab with the current buffer's path
map <leader>cd :cd %:p:h<cr>:pwd<cr> " Switch CWD to the directory of the open buffer
" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")
    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif
    if bufnr("%") == l:currentBufNum
        new
    endif
    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GOYO Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CTRL-P
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

"" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'

map <leader>j :CtrlP<cr>
"" Quickly find and open a buffer
map <leader>b :CtrlPBuffer<cr>
"" Quickly find and open a recently opened file
map <leader>f :CtrlPMRU<CR>
"
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Nerd Tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

""""""""""""""""""""""""""""""
"" => bufExplorer plugin
"""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>
