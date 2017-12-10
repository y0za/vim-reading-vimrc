let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')

" parse buffer name to file info dictionary
function! reading_vimrc#buffer#parse_name(name) abort
  let paths = split(matchstr(a:name, 'reading-vimrc://\zs.*'), '/')
  let full_keys = ['nth', 'user', 'repo', 'branch', 'path']
  let keys_num = len(full_keys)
  let keys = full_keys[0 : min([keys_num, len(paths)]) - 1]
  if len(keys) == keys_num
    let path_part = join(paths[keys_num - 1 : -1], '/')
    let paths = paths[0 : keys_num - 2] + [path_part]
  endif
  let info = {}
  for i in range(len(keys))
    let info[keys[i]] = paths[i]
  endfor
  return info
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
