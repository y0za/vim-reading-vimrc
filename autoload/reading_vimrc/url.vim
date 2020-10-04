
" parse github blob url to file info dictionary
function! reading_vimrc#url#parse_github_url(url) abort
  let pattern = 'https://github\.com/\([^/]\+\)/\([^/]\+\)/\(blob\|tree\)/\([^/]\+\)/\(.\+\)$'
  let results = matchlist(a:url, pattern)

  return {
        \  'user': results[1],
        \  'repo': results[2],
        \  'branch': results[4],
        \  'path': results[5]
        \ }
endfunction

" build raw github url from file info dictionary
function! reading_vimrc#url#raw_github_url(info) abort
  return printf('https://raw.githubusercontent.com/%s/%s/%s/%s',
        \       a:info.user,
        \       a:info.repo,
        \       a:info.branch,
        \       a:info.path)
endfunction
