" file loading tool for reading-vimrc
" Version: 0.1.0
" Author:  y0za
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')
let s:JSON = s:V.import('Web.JSON')
let s:NEXT_JSON_URL = 'http://vim-jp.org/reading-vimrc/json/next.json'

" fetch next.json from reading-vimrc website
function! reading_vimrc#fetch_next_json()
  if exists('s:next_json')
    return s:next_json
  endif

  let response = s:HTTP.get(s:NEXT_JSON_URL)
  let s:next_json = s:JSON.decode(response.content)

  return s:next_json
endfunction

" create buffers of vimrcs
function! s:load_vimrcs(vimrcs, nth)
  for vimrc in a:vimrcs
    let parsed_url = reading_vimrc#url#parse_github_url(vimrc['url'])
    let parsed_url.nth = a:nth
    let buffer_name = reading_vimrc#buffer#name(parsed_url)
    execute 'badd ' . buffer_name
  endfor
endfunction

" load reading-vimrc files
function! reading_vimrc#load()
  let vimrcs = reading_vimrc#fetch_next_json()
  call s:load_vimrcs(vimrcs[0]['vimrcs'], 'next')
endfunction

" show reading-vimrc buffer list
function! reading_vimrc#list()
  call reading_vimrc#load()
  for info in reading_vimrc#buffer#info_list()
    echo printf('%3d  %s', info.bufnr, info.name)
  endfor
endfunction

" update clipboard for reading-vimrc bot in gitter.
function! reading_vimrc#update_clipboard() range
  let splited_name = split(expand('%'), '/')
  let filename = splited_name[len(splited_name) - 1]
  let label = printf('%s#L%s-%s', filename, a:firstline, a:lastline)
  let @+ = label
  echo 'Updated clipboard : ' . label
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
