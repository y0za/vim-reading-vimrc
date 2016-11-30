
" parse github blob url to file info dictionary
function! reading_vimrc#url#parse_github_url(url) abort
  let pattern = 'https://github\.com/\([^/]\+\)/\([^/]\+\)/blob/\([^/]\+\)/\(.\+\)$'
  let results = matchlist(a:url, pattern)

  return {
        \  'user': results[1],
        \  'repo': results[2],
        \  'branch': results[3],
        \  'path': results[4]
        \ }
endfunction

" build raw github url from file info dictionary
function! reading_vimrc#url#raw_github_url(info) abort
  return printf('https://github.com/%s/%s/blob/%s/%s',
        \       a:info.user,
        \       a:info.repo,
        \       a:info.branch,
        \       a:info.path)
endfunction
