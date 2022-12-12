call plug#begin('~/.config/nvim/plugged')
    " === helpful plugins
        " seamless navigation when using vim in tmux
        Plug 'alexghergh/nvim-tmux-navigation'                      " lua
        Plug 'echasnovski/mini.nvim'                                " lua
        Plug 'mhinz/vim-startify'                                   " vim

    " === git
        Plug 'kdheepak/lazygit.nvim'                                " lua
        Plug 'rhysd/git-messenger.vim'
        Plug 'APZelos/blamer.nvim'
        Plug 'lewis6991/gitsigns.nvim'

    " === stat display
        Plug 'nvim-lualine/lualine.nvim'                            " lua

    " === lsp ===
        Plug 'neovim/nvim-lspconfig'                                " lua
        " manager of various lsp servers
        Plug 'williamboman/mason-lspconfig.nvim'                    " lua
        Plug 'williamboman/mason.nvim'                              " lua

    " === telescope
        Plug 'nvim-lua/plenary.nvim'                                " lua
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }    " lua
        Plug 'sharkdp/fd'                                           " lua
        Plug 'nvim-tree/nvim-web-devicons'                          " lua
        Plug 'nvim-telescope/telescope-symbols.nvim'
        Plug 'BurntSushi/ripgrep'

    " === autocompletion + snippets
        Plug 'hrsh7th/nvim-cmp'                                     " lua
        Plug 'hrsh7th/cmp-buffer'                                   " lua
        Plug 'hrsh7th/cmp-path'                                     " lua
        Plug 'saadparwaiz1/cmp_luasnip'                             " lua
        Plug 'hrsh7th/cmp-nvim-lsp'                                 " lua
        Plug 'L3MON4D3/LuaSnip'                                     " lua
        Plug 'rafamadriz/friendly-snippets'                         " lua
        " bracket auto closer
        Plug 'rstacruz/vim-closer'                                  " vim

    " === debugging
        Plug 'mfussenegger/nvim-dap'                                " lua
        Plug 'rcarriga/nvim-dap-ui'                                 " lua
        Plug 'mxsdev/nvim-dap-vscode-js'                            " lua
        Plug 'Weissle/persistent-breakpoints.nvim'                  " lua
        Plug 'sir-wiggles/nvim-dap-go'

    " === themes & colors
        " color codes to actual colors in vim
        Plug 'norcalli/nvim-colorizer.lua'                          " lua
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " lua
        " highlight
        Plug 'EdenEast/nightfox.nvim'
        Plug 'jacoborus/tender.vim'
        Plug 'savq/melange'
        Plug 'bluz71/vim-nightfly-colors'
        Plug 'folke/lsp-colors.nvim'
        Plug 'ellisonleao/gruvbox.nvim'

    " === xplugs
        Plug 'nvim-tree/nvim-tree.lua'
        Plug 'famiu/bufdelete.nvim'

call plug#end()

" leader key must be set before loading init.lua, some keymappings will not
" get set properly otherwise. ¯\_(ツ)_/¯
let mapleader = ','

lua require('init')

" theme
let base16colorspace=256
colorscheme gruvbox

" options
" set clipboard+=unnamedplus
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

" tmux
nnoremap <silent> <C-h>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<cr>
nnoremap <silent> <C-j>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<cr>
nnoremap <silent> <C-k>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<cr>
nnoremap <silent> <C-l>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<cr>
nnoremap <silent> <C-\>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLastActive()<cr>
nnoremap <silent> <C-Space> :lua require('nvim-tmux-navigation').NvimTmuxNavigateNext()<cr>

" tab
nnoremap <leader><c-h> :tabprevious<cr>
nnoremap <leader><c-l> :tabnext<cr>

" buffer
nnoremap <s-l> :bn<cr>
nnoremap <s-h> :bp<cr>
nnoremap <c-c> :bw<cr>

" tabs
nnoremap <c-[> gT
nnoremap <c-]> gt

" copy + paste
vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy
nnoremap <leader>cf :let @+ = expand("%")<cr>
vnoremap <leader>p  "+p
vnoremap <leader>P  "+P
nnoremap <leader>p  "+p
nnoremap <leader>P  "+P

" variables
let g:startify_fortune_use_unicode=1
let g:python3_host_prog='~/.pyenv/versions/neovim/bin/python'
let g:blamer_enabled = 1

let g:poetv_executables = ['poetry']
let g:poetv_statusline_symbol = ''
let g:poetv_auto_activate = 0

" editor
inoremap jk <esc>
inoremap JK <esc>
nnoremap <leader>h :setlocal spell! spelllang=en_us<cr>
nnoremap <leader>w :nohlsearch<cr>

nnoremap <leader>e  :edit   <c-r>=expand("%:p:h") . "/" <cr>
nnoremap <leader>es :vsplit <c-r>=expand("%:p:h") . "/" <cr>

" resize buffers
nnoremap <s-left>  :vertical resize -5<cr>
nnoremap <s-right> :vertical resize +5<cr>
nnoremap <s-down>  :resize          +5<cr>
nnoremap <s-up>    :resize          -5<cr>

" telescope
vnoremap <leader>fg "zy:Telescope live_grep default_text=<c-r>z<cr>
nnoremap <c-p> :Telescope fd<cr>
nnoremap <leader>ff :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
nnoremap <leader>fg :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>

nnoremap <leader>fb :NvimTreeToggle<cr>
nnoremap <c-b> :Bdelete<cr>

" commands
command! Git   :LazyGit
command! Grep  :Telescope live_grep
command! Debug lua require("dap").continue(); require("dapui").open()
command! Vimrc :e ~/.config/nvim/init.vim
command! Luarc :e ~/.config/nvim/lua/init.lua
command! Cmprc :e ~/.config/nvim/lua/cmp-conf.lua
command! Daprc :e ~/.config/nvim/lua/dap-conf.lua
command! Lsprc :e ~/.config/nvim/lua/lsp-conf.lua
command! Source :source ~/.config/nvim/init.vim
command! Venv  :PoetvActivate | LspRestart
command! Fb    :NvimTreeToggle

" autocmds
" highlight the yanked text for a short period of time
augroup YankHighlight
    autocmd! TextYankPost * silent! lua vim.highlight.on_yank({timeout=400})
augroup end

" strip trailing white space at the end of lines
autocmd BufWritePre * :%s/\s\+$//e

augroup daprepl
  autocmd FileType dap-repl set nobuflisted
augroup end

" highlight
highlight DapStopped    guifg=#afaf00 guibg=#3a3a3a
highlight DapBreakpoint guifg=#9b0006 guibg=#3a3a3a
highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE

