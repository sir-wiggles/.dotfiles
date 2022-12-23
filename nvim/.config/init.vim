call plug#begin('~/.config/nvim/plugged')
    " === helpful plugins
        " seamless navigation when using vim in tmux
        Plug 'alexghergh/nvim-tmux-navigation'
        Plug 'echasnovski/mini.nvim'
        Plug 'mhinz/vim-startify'
        Plug 'editorconfig/editorconfig-vim'
        Plug 'tpope/vim-eunuch'
        Plug 'qpkorr/vim-bufkill'

    " === git
        Plug 'kdheepak/lazygit.nvim'
        Plug 'rhysd/git-messenger.vim'
        Plug 'lewis6991/gitsigns.nvim'

    " === stat display
        Plug 'nvim-lualine/lualine.nvim'

    " === lsp ===
        Plug 'neovim/nvim-lspconfig'
        " manager of various lsp servers
        Plug 'williamboman/mason-lspconfig.nvim'
        Plug 'williamboman/mason.nvim'

    " === telescope
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
        Plug 'sharkdp/fd'
        Plug 'nvim-tree/nvim-web-devicons'
        Plug 'nvim-telescope/telescope-symbols.nvim'
        Plug 'BurntSushi/ripgrep'

    " === autocompletion + snippets
        Plug 'hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'saadparwaiz1/cmp_luasnip'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'L3MON4D3/LuaSnip'
        Plug 'rafamadriz/friendly-snippets'
        " bracket auto closer
        Plug 'rstacruz/vim-closer'

    " === debugging
        Plug 'mfussenegger/nvim-dap'
        Plug 'rcarriga/nvim-dap-ui'
        Plug 'mxsdev/nvim-dap-vscode-js'
        " Plug 'Weissle/persistent-breakpoints.nvim'
        Plug 'sir-wiggles/nvim-dap-go'

    " === themes & colors
        " color codes to actual colors in vim
        Plug 'norcalli/nvim-colorizer.lua'
        Plug 'nvim-treesitter/nvim-treesitter'
        Plug 'folke/lsp-colors.nvim'
        " highlight
        Plug 'EdenEast/nightfox.nvim'
        Plug 'bluz71/vim-nightfly-colors'
        Plug 'ellisonleao/gruvbox.nvim'

    " === xplugs
        Plug 'nvim-tree/nvim-tree.lua'
        Plug 'famiu/bufdelete.nvim'

call plug#end()

" leader key must be set before loading init.lua, some keymappings will not
" get set properly otherwise. ¯\_(ツ)_/¯
let mapleader = ','

lua require('init')

colorscheme nightfly

" options
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
nnoremap <silent> <c-h>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<cr>
nnoremap <silent> <c-j>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<cr>
nnoremap <silent> <c-k>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<cr>
nnoremap <silent> <c-l>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<cr>
nnoremap <silent> <c-\>     :lua require('nvim-tmux-navigation').NvimTmuxNavigateLastActive()<cr>
nnoremap <silent> <c-space> :lua require('nvim-tmux-navigation').NvimTmuxNavigateNext()<cr>

" tab
nnoremap <leader><c-h> :tabprevious<cr>
nnoremap <leader><c-l> :tabnext<cr>
nnoremap <c-[> gT
nnoremap <c-]> gt

" buffer
nnoremap <s-l> :bn<cr>
nnoremap <s-h> :bp<cr>
nnoremap <c-c> :BW<cr>

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
nnoremap <leader>ff :execute 'Telescope find_files hidden=true default_text=' . expand('<cword>')<cr>
nnoremap <leader>fg :execute 'Telescope live_grep  hidden=true default_text=' . expand('<cword>')<cr>

nnoremap <leader>fb :NvimTreeToggle<cr>
nnoremap <c-b> :Bdelete<cr>

" commands
command! Magit  :LazyGit
command! Grep   :Telescope live_grep
command! Debug  lua require("dap").continue(); require("dapui").open()
command! Vimrc  :e ~/.config/nvim/init.vim
command! Luarc  :e ~/.config/nvim/lua/init.lua
command! Cmprc  :e ~/.config/nvim/lua/cmp-conf.lua
command! Daprc  :e ~/.config/nvim/lua/dap-conf.lua
command! Lsprc  :e ~/.config/nvim/lua/lsp-conf.lua
command! Source :source ~/.config/nvim/init.vim
command! Tree   :NvimTreeToggle

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
highlight DapStopped    guifg=#24f504 guibg=default
highlight DapBreakpoint guifg=#ff3636 guibg=default
highlight FloatBorder  ctermfg=NONE ctermbg=NONE cterm=NONE

