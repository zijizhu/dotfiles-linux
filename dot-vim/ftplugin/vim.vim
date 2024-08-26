set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

let g:vim_indent = #{
    \ line_continuation: shiftwidth(),
    \ more_in_bracket_block: v:false,
    \ searchpair_timeout: 100,
    \ }
