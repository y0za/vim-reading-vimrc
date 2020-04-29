let s:V = vital#reading_vimrc#new()
let s:HTTP = s:V.import('Web.HTTP')

" parse buffer name to file info dictionary
function! reading_vimrc#buffer#parse_name(name) abort
  let paths = split(matchstr(a:name, 'readingvimrc://\zs.*'), '/')
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
  let full_keys = ['nth', 'user', 'repo', 'branch', 'path']
  let paths = map(full_keys, 'get(a:info, v:val, "")')
  return 'readingvimrc://' . join(filter(paths, 'v:val !=# ""'), '/')
endfunction

" return vimrc buffer info list
function! reading_vimrc#buffer#info_list() abort
  let info_list = []
  for info in getbufinfo()
    if info.name =~# '^readingvimrc://'
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
  if has_key(parsed_name, 'path')
    let raw_url = reading_vimrc#url#raw_github_url(parsed_name)
    let response = s:HTTP.get(raw_url)
    setlocal buftype=nofile bufhidden=hide noswapfile
    setlocal nomodeline number norelativenumber
    call s:set_content(response.content)
    filetype detect
  else
    call s:show_info_page(parsed_name.nth)
  endif
endfunction

function! s:show_info_page(nth) abort
  " TODO see nth
  let info = deepcopy(reading_vimrc#fetch_next_json()[0])
  let info.nth = a:nth
  let b:reading_vimrc_info = info

  let id = repeat(' ', 3 - len(info.id)) . info.id
  let part = info.part ==# '' ? '' : ' (' . info.part . ')'
  let header = [
        \   '第 ' . id . '回 ' . info.date,
        \   info.author.name . ' さん' . part,
        \   '-------------------------',
        \ ]
  let content = header + map(copy(info.vimrcs), 'v:val.name')

  setlocal buftype=nofile bufhidden=hide noswapfile
  setlocal nomodeline nonumber norelativenumber
  call s:set_content(content)

  nnoremap <buffer> <silent> <Plug>(reading-vimrc-open-file)
        \  :<C-u>call <SID>open_vimrc(line('.') - 4)<CR>
  nmap <buffer> <nowait> <CR> <Plug>(reading-vimrc-open-file)
endfunction

function! s:open_vimrc(n) abort
  let vimrcs = b:reading_vimrc_info.vimrcs
  if a:n < 0 || len(vimrcs) <= a:n
    return
  endif
  let vimrc = vimrcs[a:n]
  let info = reading_vimrc#url#parse_github_url(vimrc.url)
  let info.nth = b:reading_vimrc_info.nth
  let bufname = reading_vimrc#buffer#name(info)
  new `=bufname`
endfunction

function! s:set_content(content) abort
  setlocal noreadonly modifiable
  silent put =a:content
  silent 1 delete _
  setlocal readonly nomodifiable
endfunction
