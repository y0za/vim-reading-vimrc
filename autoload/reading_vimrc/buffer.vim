let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')

" parse buffer name to file info dictionary
function! reading_vimrc#buffer#parse_name(name) abort
  let pattern = 'reading-vimrc://\([^/]\+\)/\([^/]\+\)/\([^/]\+\)/\([^/]\+\)/\(.\+\)$'
  let results = matchlist(a:name, pattern)

  return {
        \  'nth': results[1],
        \  'user': results[2],
        \  'repo': results[3],
        \  'branch': results[4],
        \  'path': results[5]
        \ }
endfunction

" build buffer name from file info dictionary
function! reading_vimrc#buffer#name(info) abort
  return printf('reading-vimrc://%s/%s/%s/%s/%s',
        \       a:info.nth,
        \       a:info.user,
        \       a:info.repo,
        \       a:info.branch,
        \       a:info.path)
endfunction

" return vimrc buffer info list
function! reading_vimrc#buffer#info_list() abort
  let info_list = []
  for info in getbufinfo()
    if info.name =~# '^reading-vimrc://'
      call add(info_list, info)
    endif
  endfor
  return info_list
endfunction

" load vimrc buffer content from github
function! reading_vimrc#buffer#load_content(path) abort
  if line('$') > 1 || getline(1) != ''
    return
  endif

  let parsed_name = reading_vimrc#buffer#parse_name(a:path)
  let raw_url = reading_vimrc#url#raw_github_url(parsed_name)
  let response = s:HTTP.get(raw_url)
  setlocal noreadonly modifiable
  put =response.content
  1 delete _
  setlocal buftype=nofile bufhidden=hide noswapfile
  setlocal readonly nomodifiable nomodeline number norelativenumber
  filetype detect
endfunction
