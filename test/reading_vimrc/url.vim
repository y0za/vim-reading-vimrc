let s:suite = themis#suite('url')
let s:assert = themis#helper('assert')

function! s:suite.parse_github_url() abort
  let test_cases = [
        \ {
        \   'url': 'https://github.com/someone/dotfiles/blob/master/.vimrc',
        \   'expected': {'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': '.vimrc'}
        \ },
        \ {
        \   'url': 'https://github.com/someone/dotfiles/blob/master/vim/.vimrc',
        \   'expected': {'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': 'vim/.vimrc'}
        \ },
        \ ]
  for tc in test_cases
    call s:assert.equals(reading_vimrc#url#parse_github_url(tc.url), tc.expected)
  endfor
endfunction

function! s:suite.raw_github_url() abort
  let test_cases = [
        \ {
        \   'info': {'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': '.vimrc'},
        \   'expected': 'https://github.com/someone/dotfiles/blob/master/.vimrc'
        \ },
        \ {
        \   'info': {'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': 'vim/.vimrc'},
        \   'expected': 'https://github.com/someone/dotfiles/blob/master/vim/.vimrc'
        \ },
        \ ]
  for tc in test_cases
    call s:assert.equals(reading_vimrc#url#raw_github_url(tc.info), tc.expected)
  endfor
endfunction
