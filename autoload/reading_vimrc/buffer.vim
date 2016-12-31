let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')

" parse buffer name to file info dictionary
function! reading_vimrc#buffer#parse_name(name) abort
  let pattern = 'reading-vimrc://\([^/]\+\)/\([^/]\+\)/\([^/]\+\)/\(.\+\)$'
  let results = matchlist(a:name, pattern)

  return {
        \  'user': results[1],
        \  'repo': results[2],
        \  'branch': results[3],
        \  'path': results[4]
        \ }
endfunction

" build buffer name from file info dictionary
function! reading_vimrc#buffer#name(info) abort
  return printf('reading-vimrc://%s/%s/%s/%s',
        \       a:info.user,
        \       a:info.repo,
        \       a:info.branch,
        \       a:info.path)
endfunction

" register vimrc file as empty buffer
function! reading_vimrc#buffer#register(url) abort
  let file_info = reading_vimrc#url#parse_github_url(a:url)
  if empty(file_info)
    return
  endif

  let buffer_name = reading_vimrc#buffer#name(file_info)
  execute 'badd' buffer_name
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
function! reading_vimrc#buffer#load_content() abort
  if line('$') > 1 || getline(1) != ''
    return
  endif

  let parsed_name = reading_vimrc#buffer#parse_name(bufname('%'))
  let raw_url = reading_vimrc#url#raw_github_url(parsed_name)
  let response = s:HTTP.get(raw_url)
  put =response.content
  1 delete _
endfunction
