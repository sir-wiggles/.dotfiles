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
" ------------------ tab --------------------
nnoremap <leader><c-h> :tabprevious<cr>
nnoremap <leader><c-l> :tabnext<cr>
" ----------------- buffer ------------------
nnoremap <s-l> :bn<cr>
nnoremap <s-h> :bp<cr>
nnoremap <c-c> :bw<cr>
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
