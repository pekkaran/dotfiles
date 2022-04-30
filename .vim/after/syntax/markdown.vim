" This alters the value specified in
" `/usr/share/vim/vim<ver>/syntax/markdown.vim` to remove the underscore in it.
" That causes vim to not show a red error on an unmatched underscore, which are
" used for making text bold. I don't want that because I use underscore in names
" rather than for emphasis. An alternative fix is to use a different markdown
" specification which doesn't have this problem, but that might affect the
" html conversion of my existing docs.
" <https://github.com/tpope/vim-markdown/issues/21#issuecomment-283846940>
" <https://stackoverflow.com/a/23486642>
syn match markdownError "\w\@<=\w\@="
