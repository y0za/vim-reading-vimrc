let s:suite = themis#suite('url')
let s:assert = themis#helper('assert')

function! s:suite.parse_name() abort
  let test_cases = [
        \ {
        \   'name': 'reading-vimrc://next/someone/dotfiles/master/.vimrc',
        \   'expected': {'nth': 'next', 'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': '.vimrc'}
        \ },
        \ {
        \   'name': 'reading-vimrc://next/someone/dotfiles/master/vim/.vimrc',
        \   'expected': {'nth': 'next', 'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': 'vim/.vimrc'}
        \ },
        \ ]
  for tc in test_cases
    call s:assert.equals(reading_vimrc#buffer#parse_name(tc.name), tc.expected)
  endfor
endfunction

function! s:suite.name() abort
  let test_cases = [
        \ {
        \   'info': {'nth': 'next', 'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': '.vimrc'},
        \   'expected': 'reading-vimrc://next/someone/dotfiles/master/.vimrc'
        \ },
        \ {
        \   'info': {'nth': 'next', 'user': 'someone', 'repo': 'dotfiles', 'branch': 'master', 'path': 'vim/.vimrc'},
        \   'expected': 'reading-vimrc://next/someone/dotfiles/master/vim/.vimrc'
        \ },
        \ ]
  for tc in test_cases
    call s:assert.equals(reading_vimrc#buffer#name(tc.info), tc.expected)
  endfor
endfunction

