
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
