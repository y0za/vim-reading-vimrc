" file loading tool for reading-vimrc
" Author:  y0za
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')
let s:JSON = s:V.import('Web.JSON')
let s:NEXT_JSON_URL = 'http://vim-jp.org/reading-vimrc/json/next.json'

" fetch next.json from reading-vimrc website
function! s:fetch_next_json()
  if exists('s:next_json')
    return s:next_json
  endif

  let response = s:HTTP.get(s:NEXT_JSON_URL)
  let s:next_json = s:JSON.decode(response.content)

  return s:next_json
endfunction

" convert to raw github url
function! s:to_raw_url(url)
  let url = substitute(a:url, 'github.com', 'raw.githubusercontent.com', '')
  return substitute(url, 'blob\/', '', '')
endfunction

" create buffuers of vimrcs
function! s:load_vimrcs(vimrcs)
  for vimrc in a:vimrcs
    let raw_url = s:to_raw_url(vimrc['url'])
    execute 'badd ' . raw_url
  endfor
endfunction

" load reading-vimrc files
function! reading_vimrc#load()
  let vimrcs = s:fetch_next_json()
  call s:load_vimrcs(vimrcs[0]['vimrcs'])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
