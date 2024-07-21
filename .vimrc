" Enable line number
set number

" Use true colors
set termguicolors

" Share clipboard with system
set clipboard^=unnamed

" Override editor cursor settings and use block for cursor
" Source: https://stackoverflow.com/q/6488683/17662217
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END


" Key mappings
let mapleader = " "
nnoremap L $
nnoremap H ^
nnoremap <Leader>e :Explore<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>rg :Rg<CR>


" Plugins
call plug#begin()

" Essentials
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" Fuzzy Find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP and autocomplete
Plug 'yegappan/lsp'
Plug 'girishji/vimcomplete'
Plug 'girishji/autosuggest.vim'

" Appearance
Plug 'morhetz/gruvbox'
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vimwiki
Plug 'vimwiki/vimwiki'

" VimTex
Plug 'lervag/vimtex'

call plug#end()

" vim-airline tweaks
" Source 1: https://vi.stackexchange.com/q/37577
" Source 2: https://vi.stackexchange.com/q/22046
" Source 3: https://github.com/vim-airline/vim-airline/issues/193
let g:airline_powerline_fonts = 1
let g:airline_symbols = {}
let g:airline_symbols.colnr = ''
let g:airline_symbols.maxlinenr = ''

" colorscheme settings
let g:gruvbox_contrast_dark = 'hard'
set background=dark
colorscheme gruvbox

set rtp^="/Users/zhijiezhu/.opam/default/share/ocp-indent/vim"


" VimComplete Configurations
let vimcomplete_tab_enable = 1


" LSP Configurations
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
    \ name: 'pylsp',
    \ filetype: ['python'],
    \ path: '/opt/homebrew/bin/pylsp',
    \ args: []
    \ }, #{
    \ name: 'bashls',
    \ filetype: 'sh',
    \ path: '/Users/zhijiezhu/.nvm/versions/node/v20.12.2/bin/bash-language-server',
    \ args: ['start'],
    \ }, #{
    \ name: 'vimls',
    \ filetype: 'vim',
    \ path: '/Users/zhijiezhu/.nvm/versions/node/v20.12.2/bin/vim-language-server',
    \ args: ['--stdio'],
    \ }]

autocmd User LspSetup call LspAddServer(lspServers)

