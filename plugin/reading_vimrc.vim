" file loading tool for reading-vimrc
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


let &cpo = s:save_cpo
unlet s:save_cpo
