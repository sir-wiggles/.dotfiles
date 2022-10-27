call plug#begin('~/.config/nvim/plugged')
    Plug 'mfussenegger/nvim-dap'
"    Plug 'rcarriga/nvim-dap-ui'
    " seamless navigation when using vim in tmux
    Plug 'alexghergh/nvim-tmux-navigation'                      " lua
    "
    " pretty icons in vim, a must have
    Plug 'kyazdani42/nvim-web-devicons'                         " lua
    Plug 'nvim-lualine/lualine.nvim'                            " lua

    Plug 'neovim/nvim-lspconfig'                                " lua
    Plug 'echasnovski/mini.nvim'                                " lua
    Plug 'ibhagwan/fzf-lua', {'branch': 'main'}                 " lua
    Plug 'kdheepak/lazygit.nvim'                                " lua

    " manager of various lsp servers
    Plug 'williamboman/mason.nvim'                              " lua
    Plug 'williamboman/mason-lspconfig.nvim'                    " lua

    " better syntax highlighting
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " lua

    " ========= experimental plugins ==========
    Plug 'norcalli/nvim-colorizer.lua'                          " lua
    Plug 'mhinz/vim-startify'                                   " vim
    "Plug 'lifepillar/vim-mucomplete'                            " vim

    " ========= experimental plugins ==========
call plug#end()

" Setup all the Lua plugins
lua require('init')

" ===========================================
" ================ options ==================
" ===========================================
set clipboard+=unnamedplus
set cmdheight=1
set colorcolumn=90
set cursorline
set encoding=utf-8
set expandtab
set nofoldenable
set nowrap
set number
set relativenumber
set scrolloff=5
set shiftround
set shiftwidth=4
set shortmess+=c
set sidescrolloff=10
set signcolumn=yes
set splitbelow
set splitright
set tabstop=4
set wildmenu
set wildmode=longest:full,full
" -------------------------------------------

" ===========================================
" =============== navigation ================
" ===========================================
" ------------------ tmux -------------------
nnoremap <silent> <C-h>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<cr>
nnoremap <silent> <C-j>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<cr>
nnoremap <silent> <C-k>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<cr>
nnoremap <silent> <C-l>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<cr>
nnoremap <silent> <C-\>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLastActive()<cr>
nnoremap <silent> <C-Space> :lua require('nvim-tmux-navigation').NvimTmuxNavigateNext()<cr>
" ------------------ tab --------------------
nnoremap <leader><c-h> :tabprevious<cr>
nnoremap <leader><c-l> :tabnext<cr>
" ----------------- buffer ------------------
nnoremap <s-l> :bn<cr>
nnoremap <s-h> :bp<cr>
nnoremap <c-c> :bw<cr>
" -------------------------------------------

" ===========================================
" ============== copy + paste ===============
" ===========================================
vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
nnoremap <leader>ff :let @+ = expand("%")<cr>
vnoremap <leader>p  "+p
vnoremap <leader>P  "+P
nnoremap <leader>p  "+p
nnoremap <leader>P  "+P
" -------------------------------------------

" ===========================================
" ============= =============== =============
" ===========================================
" --------------- variables -----------------
let mapleader = ','
let g:startify_fortune_use_unicode=1
" ---------------- i-remaps -----------------
inoremap jk <esc>
inoremap JK <esc>
" ---------------- n-remaps -----------------
nnoremap <leader>h :setlocal spell! spelllang=en_us<cr>
nnoremap <c-w> :nohlsearch<cr>
nnoremap <c-p> <cmd>lua require('fzf-lua').files()<cr>
" resize buffers relative to others in the vim session
nnoremap <s-left>  :vertical resize -5<cr>
nnoremap <s-right> :vertical resize +5<cr>
nnoremap <s-down>  :resize          +5<cr>
nnoremap <s-up>    :resize          -5<cr>
" ---------------- commands -----------------
command! Grep lua require('fzf-lua').grep()
command! Git  :LazyGit

" ---------------- autocmds -----------------
" highlight the yanked text for a short period of time
augroup YankHighlight
    autocmd! TextYankPost * silent! lua vim.highlight.on_yank({timeout=400})
augroup end
" strip trailing white space at the end of lines
autocmd BufWritePre * :%s/\s\+$//e
" -------------------------------------------

nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>


