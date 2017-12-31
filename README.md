# vim-reading-vimrc

[![Build Status](https://travis-ci.org/y0za/vim-reading-vimrc.svg?branch=master)](https://travis-ci.org/y0za/vim-reading-vimrc)

file loading tool for [vimrc読書会](http://vim-jp.org/reading-vimrc/)

## Usage

### Commands
```vim
" show next reading-vimrc info
:ReadingVimrcNext

" create next reading-vimrc buffers and show those names
:ReadingVimrcList

" load next reading-vimrc as buffers
:ReadingVimrcLoad
```

### Config
```
" register label to clipboard
vmap <Leader><CR> <Plug>(reading_vimrc-update_clipboard)
```

## License
MIT License
