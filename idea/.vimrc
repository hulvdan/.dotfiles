" Copied from https://github.com/IlyasYOY/dotfiles/blob/master/.ideavimrc
syntax on
filetype plugin on
set nocompatible

set list listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<

let mapleader = " "
let mapleaderlocal = " "

" Allows me to use custom vimrc from the current folder
set exrc

" Essential shiet
set nu
set relativenumber
set noerrorbells
set belloff=all
set termguicolors
set hidden

" Tabs and indent settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Swap files
set noswapfile
set nobackup

" Undo files
set undodir=~/.vim/undodir
set undofile

set incsearch

" Number of lines to keep above/below the cursor
set scrolloff=8

" Column with extra info
set signcolumn=yes
set foldcolumn=1

" Line length column
set colorcolumn=80
set cursorline

" autocomplete for command mode
set wildmenu
set wildmode=full

" increase history size
set history=50

" noh - no highlight
nnoremap <Esc> :noh <CR>

set wrap

" ===== Greatest Remaps Ever =====
" Yank + Paste to the OS clipboard
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>P "+P
" xmap <leader>p "_dP

" Copy line after spaces till the end not including \n character
nnoremap <S-y> mz^v$y`z

" Keeping cursor in the middle when moving up / down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Joining string without moving screen
nnoremap J mzJ`z

" Move lines up / down in visual mode
vnoremap J Vdp
vnoremap K VdkP

" Toggle case and start typing. E.g. `<leader>iget`: `property` -> `getProperty`
map <leader>i ~hi

" Remove file content
nmap <C-S-d> ggVGd

" ===== Other stuff =====

set langmap=йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj,лk,дl,ж\\;,э',ё\\,яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж:,Э\\",ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б<,Ю>,Ё/|

imap <C-ц> <C-w>
imap <C-х> <C-[>
imap <C-щ> <C-o>

" Save With Space-W
noremap <leader>w :w<cr>
noremap <leader>q :wq<cr>
