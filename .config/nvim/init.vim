call plug#begin('$HOME/.config/nvim/plugins')
Plug 'crusoexia/vim-monokai'
call plug#end()

colorscheme monokai
set clipboard=unnamedplus
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
