" file loading tool for reading-vimrc
" Version: 0.1.0
" Author:  y0za
" License: MIT License

if exists('g:loaded_reading_vimrc')
  finish
endif
let g:loaded_reading_vimrc = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0
      \ ReadingVimrcLoad
      \ call reading_vimrc#load()

command! -nargs=0
      \ ReadingVimrcList
      \ call reading_vimrc#list()

vnoremap <Plug>(reading_vimrc-update_clipboard) :call reading_vimrc#update_clipboard()<CR>

augroup reading_vimrc
  autocmd!
  autocmd BufReadCmd reading-vimrc://*
  \   call reading_vimrc#buffer#load_content(expand('<amatch>'))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
