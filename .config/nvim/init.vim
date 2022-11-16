call plug#begin('~/.config/nvim/plugged')
    " === Helpful plugins
        " seamless navigation when using vim in tmux
        Plug 'alexghergh/nvim-tmux-navigation'                      " lua
        Plug 'echasnovski/mini.nvim'                                " lua
        Plug 'kdheepak/lazygit.nvim'                                " lua
        Plug 'mhinz/vim-startify'                                   " vim

    " === Stat display
        Plug 'nvim-lualine/lualine.nvim'                            " lua

    " === LSPs ===
        Plug 'neovim/nvim-lspconfig'                                " lua
        " manager of various lsp servers
        Plug 'williamboman/mason-lspconfig.nvim'                    " lua
        Plug 'williamboman/mason.nvim'                              " lua

    " === Coloring
        " color codes to actual colors in vim
        Plug 'norcalli/nvim-colorizer.lua'                          " lua
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " lua

    " === Telescope
        Plug 'nvim-lua/plenary.nvim'                                " lua
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }    " lua
        Plug 'sharkdp/fd'                                           " lua
        Plug 'nvim-tree/nvim-web-devicons'                          " lua

    " === Autocompletion + Snippets
        Plug 'hrsh7th/nvim-cmp'                                     " lua
        Plug 'hrsh7th/cmp-buffer'                                   " lua
        Plug 'hrsh7th/cmp-path'                                     " lua
        Plug 'saadparwaiz1/cmp_luasnip'                             " lua
        Plug 'hrsh7th/cmp-nvim-lsp'                                 " lua
        Plug 'L3MON4D3/LuaSnip'                                     " lua
        Plug 'rafamadriz/friendly-snippets'                         " lua

        " bracket auto closer
        Plug 'rstacruz/vim-closer'                                  " vim

    " === Debugging
        Plug 'mfussenegger/nvim-dap'                                " lua
        Plug 'rcarriga/nvim-dap-ui'                                 " lua
        Plug 'mxsdev/nvim-dap-vscode-js'                            " lua
        Plug 'Weissle/persistent-breakpoints.nvim'                  " lua

    " === xplugs
        Plug 'rhysd/git-messenger.vim'
        Plug 'APZelos/blamer.nvim'
        Plug 'chriskempson/base16-vim'
        Plug 'BurntSushi/ripgrep'

call plug#end()

" leader key must be set before loading init.lua
let mapleader = ','

" Setup all the Lua plugins
lua require('init')

let base16colorspace=256
colorscheme base16-ia-dark

" ---------------- options ------------------
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

" =============== navigation ================
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
" -------------- copy + paste ---------------
vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
nnoremap <leader>ff :let @+ = expand("%")<cr>
vnoremap <leader>p  "+p
vnoremap <leader>P  "+P
nnoremap <leader>p  "+p
nnoremap <leader>P  "+P
" --------------- variables -----------------
let g:startify_fortune_use_unicode=1
let g:python3_host_prog='~/.pyenv/versions/neovim/bin/python'

let g:blamer_enabled = 1
" ---------------- i-remaps -----------------
inoremap jk <esc>
inoremap JK <esc>
" ---------------- n-remaps -----------------
nnoremap <leader>h :setlocal spell! spelllang=en_us<cr>
nnoremap <c-w> :nohlsearch<cr>
nnoremap <c-p> :Telescope fd<cr>
" resize buffers relative to others in the vim session
nnoremap <s-left>  :vertical resize -5<cr>
nnoremap <s-right> :vertical resize +5<cr>
nnoremap <s-down>  :resize          +5<cr>
nnoremap <s-up>    :resize          -5<cr>
" ---------------- commands -----------------
command! Git   :LazyGit
command! Grep  :Telescope live_grep
command! Debug lua require("dap").continue(); require("dapui").open()
command! Vimrc :e ~/.config/nvim/init.vim
command! Luarc :e ~/.config/nvim/lua/init.lua
command! Cmprc :e ~/.config/nvim/lua/cmp-conf.lua
command! Daprc :e ~/.config/nvim/lua/dap-conf.lua
command! Lsprc :e ~/.config/nvim/lua/lsp-conf.lua
command! Source :source ~/.config/nvim/init.vim
" ---------------- autocmds -----------------
" highlight the yanked text for a short period of time
augroup YankHighlight
    autocmd! TextYankPost * silent! lua vim.highlight.on_yank({timeout=400})
augroup end

" strip trailing white space at the end of lines
autocmd BufWritePre * :%s/\s\+$//e

augroup daprepl
  autocmd FileType dap-repl set nobuflisted
augroup end
" ---------------- highlight ----------------
highlight DapStopped    guifg=#afaf00 guibg=#3a3a3a
highlight DapBreakpoint guifg=#9b0006 guibg=#3a3a3a
highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE
" -------------------------------------------

