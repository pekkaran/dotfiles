" Configuration for vim and neovim.
"
" * In vim, press right to open a fold, use `zR` to open all the folds.
" * A lot of the things in this file are copy-pasted from great configs by others, such as:
"   * <https://bitbucket.org/sjl/dotfiles/src/default/vim/vimrc>
"   * <https://github.com/casey/local/blob/master/etc/vimrc>
" * For a bunch of great vim stuff, see:
"   * <https://github.com/tpope>
"   * <https://github.com/Shougo>
"
" Main set {{{
" Non vi-compatible.
set nocompatible

" Could be used to set OS-dependent options.
let s:uname = system("echo -n \"$(uname)\"")

" Plugin manager.
runtime bundle/vim-pathogen/autoload/pathogen.vim
let g:pathogen_disabled = []
" call add(g:pathogen_disabled, 'disabled-plugin-name-goes-here')
execute pathogen#infect()

" Color scheme. But why do I have two solarized plugins?
set background=dark
set termguicolors
" let g:solarized_italics = 0
colorscheme solarized8

" Highlight current line number.
autocmd! ColorScheme * hi CursorLineNR ctermfg=white

" Searching.
set incsearch " Search while typing.
set ignorecase " Ignore case in search …
set smartcase " … unless it's upper.
set hlsearch

syntax enable
set title
set noerrorbells
set noswapfile
set nobackup
set showcmd " Show command information.
set cursorline " Enable cursor highlight.
set number " Show line numbers.
set timeoutlen=1000 " Timeout in milliseconds for leader commands and combos (e.g. the common 'jk' -> Esc).
set noruler
set laststatus=2
set nomodeline " Modelines are disabled by default because of possible security issues.
set modelines=0
set backspace=indent,eol,start " Backspace behaviour (indent -> eol -> start)"
set tabpagemax=20 " How many tabs can be opened with -p command.
set noshowmode " Do not show stuff on the status line because we have the airline plugin.
set showtabline=2
set scrolloff=10 " Minimum number of lines to always show below and above cursor.
set showmatch " When a bracket is inserted, briefly jump to the matching one.
set matchpairs+=<:> " Also match < > with %.
set hidden " Buffer behavior.
set confirm " Buffer behavior.
set shortmess+=I " Disable welcome message when starting vim without a file argument.
set gdefault " Make `s///` behave like `s///g` and vice versa.
set splitbelow " New split placement.
set splitright
" uhex:     Show unprintable chars as <xx> instead of ^C.
" lastline: Do no replace partially visible wrapped lines with
"           stacks of '@' symbols.
set display=uhex,lastline
set wrap " Wrap lines that don't fit to screen …
set linebreak " … but only wrap at characters listed in `breakat`.
set virtualedit=block " Free block placement in visual mode
set nojoinspaces " When joining to line that ends in period, do not insert two spaces.
set clipboard+=unnamedplus " Yanks and deletes additionally go to the + register, so you can paste them with ctrl-v.
set breakindent " Show soft-wrapped text with leading indent.
set undolevels=1000 " Remember this many changes.

" Use `.tags` instead of `tags` for ctags file.
set tags=.tags;
au BufReadPost .tags set syntax=tags

" Indenting. Some of these will likely be overrided by the `editorconfig` plugin.
set tabstop=4
set shiftwidth=4
set autoindent
set shiftround " Round indent to multiple of shiftwidth when using < and >.
set smarttab " Insert blanks according to shiftwidth.

" Text width and autowrapping.
" set textwidth=79
" set formatoptions=cq

" From casey:
set formatoptions +=2 " Use paragraph second line indent
set formatoptions +=c " Auto-wrap comments at textwidth
set formatoptions +=j " Merge comments when joining lines
set formatoptions +=q " Allow formatting comments with `gq`
set formatoptions +=r " Insert comment leader after <enter> in insert mode
set formatoptions +=t " Auto-wrap at textwidth
set formatoptions -=a " Disable automatic formatting of paragraphs
set formatoptions -=l " Format long lines when inserting
" let g:rust_recommended_style=0 " Also apply textwidth for Rust. See :help rust.

" Show tabs and trailing whitespace …
set list
set listchars=tab:--,trail:-,extends:#,nbsp:-
" … but don't show trailing whitespace in insert mode.
augroup trailing
  au!
  au InsertEnter * :set listchars-=trail:-
  au InsertLeave * :set listchars+=trail:-
augroup END

" Visual autocomplete for command menu.
set wildmenu
set wildmode=longest,list,full
" From sjl:
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.DS_Store                       " OSX bullshit

" Don't try to highlight lines longer than this many characters.
set synmaxcol=600

" Language of vim.
set helplang=en
set langmenu=en

" Set indentation rules for C/C++ programs.
set cinoptions=l1,g0,+s,N-s,E-s,(s,k2s,U1,m1

" TODO Trying out:
set startofline " Some movement commands like C-d, G, and :<num> place cursor on first non-blank character.

" }}}
" File handling {{{

" Language/encoding of edited files.
" set encoding=utf-8
" Failing to open a file using default encodings, test all the Japanese
" encodings supported by vim (for list, see :help mbyte-encoding).
" If you come across a file with undetected coding, try
" running `file <file>` for a clue what to add to this list.
set fileencodings=ucs-bom,utf-8,default,latin1,iso-2022-jp,euc-jp,sjis,cp932
" TODO The above doesn't seem to work. I was able to read a `sjis` file with
" `:e ++enc=sjis` after opening the file.

" Detect filetypes.
filetype detect
filetype on
filetype plugin on
filetype plugin indent on

" The JSON syntax highlighter does not support JSONL, but works well enough
" since we rarely intend to edit JSONL files, just view them.
augroup jsonl
  au!
  autocmd BufNewFile,BufRead *.jsonl set syntax=json
augroup END

" Folding.
" Use `:help fold` for the commands, which I always forget. Summary:
"   zR: open all folds
"   zM: close all folds
"   zO or right movement: open fold
"   zc: close a fold
autocmd FileType vim setlocal foldmethod=marker
" autocmd FileType cpp setlocal foldmethod=syntax
" autocmd FileType cpp setlocal nofoldenable

" Return to last edit position when opening files.
" autocmd BufReadPost *
"   \ if line("'\"") > 0 && line("'\"") <= line("$") |
"   \   exe "normal! g`\"" |
"   \ endif

" Check regularly if the file has been changed by some other program.
set autoread
augroup checktime
  au!
  if !has("gui_running")
    autocmd BufEnter     * silent! checktime
    autocmd CursorHold   * silent! checktime
    autocmd CursorHoldI  * silent! checktime
    autocmd CursorMoved  * silent! checktime
    autocmd CursorMovedI * silent! checktime
  endif
augroup END

" Limit git commit second paragraph width
autocmd Filetype gitcommit setlocal spell textwidth=72

" Add git project root to path. This allows for easier finding with vim.
" The substitution removes terminating null character.
" Nothing bad happens if the git rev-parse fails outside a git repository.
let s:cdg = substitute(system("git rev-parse --show-toplevel"), '\%x00', '', 'g')
let &path = &path.','.s:cdg

" Only show cursorline in the current window and in normal mode
augroup cline
  au!
  au WinLeave,InsertEnter * set nocursorline
  au WinEnter,InsertLeave * set cursorline
augroup END

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' \\/.*$^~[]#')

" }}}
" Keymaps {{{

let mapleader=","

" Copy and paste.
"
"Vim offers the + and * registers to reference the system clipboard (:help quoteplus and :help quotestar). Note that on some systems, + and * are the same, while on others they are different. Generally on Linux, + and * are different: + corresponds to the desktop clipboard (XA_SECONDARY) that is accessed using CTRL-C, CTRL-X, and CTRL-V, while * corresponds to the X11 primary selection (XA_PRIMARY), which stores the mouse selection and is pasted using the middle mouse button in most applications.
"
" NOTE that these (the * and + registers) do not work without a clipboard
" tool vim can work with, for example `xclip`. See :help clipboard for
" details.
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>y "+ygv
" vnoremap <C-c> "+yi
" vnoremap <C-x> "+c
" vnoremap <C-v> c<ESC>"+p
inoremap <C-v> <C-r><C-o>+

" To quickly go to line 42, type '42,,'
nnoremap <leader><leader> Gzz

" Add todo note for a search program. `gcc` comments the line (a plugin), and `==`
" indents it.
nmap <leader>t O<esc>"=strftime('TODO STACK %Y_%m_%d-%T')<cr>pgcc==

" Open netrw split on the right side.
nnoremap <leader>n :Vexplore!<cr>

" Tags (eg ctags):
" Go to definition under cursor.
nnoremap <leader>j <C-]>
nnoremap <C-]> <nop>
" Go back to previous location after <C-]>.
nnoremap <leader>k <C-t>
" Next definition of last tag.
nnoremap <leader>u :tn<cr>
" List definitons of last tag.
nnoremap <leader>l :ts<cr>

" Own functions, defined later.
nnoremap <leader>e :call OpenFirstErrorLine(1)<cr>
nnoremap <leader>E :call OpenFirstErrorLine(0)<cr>
nnoremap <leader>w :call OpenNextErrorLine(1)<cr>
nnoremap <leader>W :call OpenNextErrorLine(-1)<cr>
nnoremap <leader>r :call OpenTodoLine(1)<cr>

" vim-abolish plugin: Swap boolean values in selection or current line.
" Note that numbers on line may be similarly incremented or decremented using
" the built-in <c-a> and <c-x> commands.
vnoremap <leader>b :Subvert/{true,false}/{false,true}<cr>:nohl<cr>
nnoremap <leader>b :.Subvert/{true,false}/{false,true}<cr>:nohl<cr>
" Some abbreviations I use produce template code with placeholder variables like `Xx`.
vnoremap <leader>2 :Subvert/{Xx,Yy}/{
nnoremap <leader>2 :.Subvert/{Xx,Yy}/{

" vim-clang-format plugin.
" nnoremap <leader>F :<C-u>ClangFormat<cr>
" vnoremap <leader>F :ClangFormat<cr>

" Leave the small number function keys unused.
nnoremap <F1> <nop>

" Remove all trailing whitespace.
" nnoremap <F9> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Edit previous and next file by alphabetical sort.
" From <https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim>
nnoremap <silent> <F7> :<C-U>edit <C-R>=<SID>fnameescape(fnamemodify(<SID>FileByOffset(v:count1), ':.'))<CR><CR>
nnoremap <silent> <F9> :<C-U>edit <C-R>=<SID>fnameescape(fnamemodify(<SID>FileByOffset(-v:count1), ':.'))<CR><CR>

" These days vim can paste things without paste mode, but it's occasionally
" useful for typing things without interference from `imap`s.
set pastetoggle=<F10>

" Can't map unmodified F11?
nnoremap <S-F11> :call OpenRandomFile()<cr>

" Open hpp file buffer from cpp file and vice versa. Very crude.
nnoremap <leader>z :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<cr>

" Insert mode timeout combinations.
" These interfere with typing somewhat, so only start them with 'j' to
" minimize the effects.
"
" Escape mapping.
" To escape visual mode without the hard to reach <esc>, use the key you entered
" with (v, V or <c-v>), <c-c>, or <c-[>.
inoremap jk <esc>
inoremap Jk <esc>
inoremap JK <esc>
inoremap jjk <esc>
inoremap <esc> <nop>
" New line in insert mode.
inoremap <cr> <nop>
inoremap <C-l> <C-j>
nnoremap <C-l> o
inoremap jf <C-j>

" Quick save.
nnoremap <leader>m :w<cr>
" This wasn't a very good shortcut because I couldn't type 'json'.
" inoremap js <esc>:w<cr>

" Trying to learn use <c-h>. Be aware also of <c-w> and <c-u> which delete back word
" or the entire line.
inoremap <backspace> <nop>

" Normally this cycles between normal-insert-replace modes.
inoremap <insert> <nop>
nnoremap <insert> <nop>
vnoremap <insert> <nop>

" Do not use 'select mode'.
vnoremap <C-g> <nop>

" Colon commands are common so put them behind the easier to type '.' and
" remap the repetition key. `\` is normally the leader key.
nnoremap . :
vnoremap . :
nnoremap \ .
vnoremap \ .

" Use one pinky finger instead of two for the register key.
nnoremap ; "
vnoremap ; "

" The black hole register. Prefix delete commands with this to not yank them
nnoremap ;; "_
vnoremap ;; "_

" System clipboard register (the one I use).
nnoremap ;p "+

" Indent in visual and select mode automatically re-selects. I find it enough
" to use the repeat key.
" vnoremap > >gv
" vnoremap < <gv

" By default ^ returns to the first non-whitespace character and 0 to the
" first character. Remapped because of how I happened to learn use one before
" the other. Mnemonic: # is left of $, and how in C/C++ `#macros` are often
" idented to the first column.
nnoremap 0 ^
nnoremap # 0
nnoremap ^ <nop>

" Don't move on *, which searches for the word under cursor.
nnoremap * :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

" By default q is the macro recording key. Hard to exit when you press it by accident.
nnoremap + q
nnoremap q <nop>

" Kind of like the opposite of `J`, this command splits lines on space.
" By default K opens man page for word under cursor.
nnoremap K i<return><esc>

" Often I want to yank text in visual mode, but accidentally hitting `u` instead of `y`.
vnoremap u <nop>

" Backwards search. Easier to just search forward and cycle matches the other
" direction.
nnoremap ? <nop>

" Never put single deleted characters into the unnamed register.
nnoremap x "_x
nnoremap X "_X

" Delete [count] lines without putting them in the unnamed register. Useful for empty lines.
" Disabled because I actually wanted to use the original command ("delete to").
" nnoremap df "_dd

" Paste the last yanked text, ignoring the deleted stuff that goes in the unnamed register.
" nnoremap cp "0p

" Previous, next and close buffer.
nnoremap H :bp<cr>
nnoremap L :bn<cr>
nnoremap Q :bd<cr>

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" vimspeak uses combinations beginning with S. Disable to reduce mistyping.
" nnoremap S <nop>

" Generate curly brackets block and leave in insert mode inside. Could be more
" robust. I have mapped to keys like ¹²³ from alt-123….
nnoremap ¹      :.s/\s\+$//e<cr>:nohl<cr>A {<return>}<esc>O
inoremap ¹ <esc>:.s/\s\+$//e<cr>:nohl<cr>A {<return>}<esc>O
" Rust `match` block.
nnoremap ²      :.s/\s\+$//e<cr>:nohl<cr>A => {<return>},<esc>O
inoremap ² <esc>:.s/\s\+$//e<cr>:nohl<cr>A => {<return>},<esc>O

" Normally <C-o> allows exectuing normal mode commands from insert mode, but I use <C-o> for
" opening files.
inoremap <C-i> <C-o>

" Move individual lines up and down. I use this all the time. Especially handy
" with `J` and `K` (latter is a custom command defined in this file).
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
inoremap <C-j> <nop>
inoremap <C-k> <nop>

" Grep-like search plugin.
nmap <C-f> <plug>(esearch)

" Uppercase previous word under cursor in insert mode. The idea is to use it as kind of
" postfix caps lock.
" inoremap <C-u> <esc>mzgUiw`za

" Substitute text.
nnoremap <C-e> :%s/
vnoremap <C-e> :s/
nnoremap <C-s> :%Subvert/
vnoremap <C-s> :Subvert/

" My file opening functions.
nnoremap <C-o> :call GitOpen()<cr>
nnoremap <C-i> :call DmenuOpen()<cr>

" Toggle line numbers.
nnoremap <C-n> :setlocal number!<cr>

" Clear junk from the screen.
function! Reset()
  cexpr []
  cclose
  echo
endfunction
" Use a mark because for some reason the space always moves the cursor.
nnoremap <silent> <space> mz:nohl<cr> :call Reset()<cr>`z

" Center after search.
nnoremap n nzz
nnoremap N Nzz

" Disabled because I'm now using the supertab plugin.
" A completion popup launched with tab. <C-e> hides the popup (don't map it to
" esc, it will cause issues with the arrow keys).
" inoremap <expr><tab> pumvisible() ? "\<C-o>" : "\<C-x>\<C-o>"
" inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>"
" inoremap <expr><return> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Show the menu even if there's only one match
" set completeopt=menuone

" Follow links and go back in help pages
au FileType help nnoremap <return> <C-]>
au FileType help nnoremap <backspace> <C-T>

" Allows writing to files with root privileges
" cmap w!! %!sudo tee > /dev/null %

" }}} Netrw {{{
let g:netrw_banner = 0
" 4 means open the file in previous window.
let g:netrw_browse_split = 4
" Split size in percents.
let g:netrw_winsize = 25
" ?
autocmd FileType netrw setl bufhidden=wipe

" }}}
" {{{ Plugins

" vim-abolish
" Includes a version of s/old/new that preserves case in programming sense.
" :%Subvert/old/new/g  does the following replaces in the whole file:
" * s/OLD/NEW/
" * s/Old/New/
" * s/old/new/

" vim-addon-local-vimrc
" Applies settings from additional .vimrc:s that are somewhere in the
" parent folder sequence. Use this to customize vim for working with files of
" some specific project, e.g. non-programming writing.

"" Plugins with settings

" }}}
" {{{ * vim-cpp-modern
"let g:cpp_no_function_highlight = 1
" }}}
" {{{ * esearch
let g:esearch = {} " Needed before specifying custom options.
" Open the search window in a new buffer (:e) instead of tab.
let g:esearch.win_new = {esearch -> esearch#buf#goto_or_open(esearch.name, 'e') }
" }}}
" {{{ * vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_theme='solarized'
let g:airline_theme='base16_solarized_dark'
" let g:airline_section_c = '%-0.27{expand("%:p")}' " full path to the file
let g:airline_section_c = '%-0.35{expand("%:p:h")}' " full path to the directory in which the file is
let g:airline_section_z = '%p%%' " Just the percentage, no row or column numbers.
" }}}
" {{{ * vimspeak
" <https://git.sr.ht/~sircmpwn/dotfiles/tree/master/lib/vim/vimspeak.vim>
" let g:vimspeak_enabled = 1
" source ~/arch/.vim/vimspeak.vim
" }}}
" {{{ * (unused) ron
let g:ron_recommended_style = 0
" }}}
" {{{ * (unused) vim-clang-format
let g:clang_format#detect_style_file = 1 " use .clang-format file …
let g:clang_format#enable_fallback_style = 0 " … and nothing but the .clang-format
" }}}
" {{{ * (unused) vim-clang
" Note that this plugin conflicts with vim-clang-format, defining same
" commands.
let g:clang_auto = 0 " 0 requires pressing tab before showing completions
let g:clang_check_syntax_auto = 0 " check syntax on file save
let g:clang_verbose_pmenu = 1 " show types and such in the omnicomplete menu
" }}}
" {{{ Rust
au BufRead,BufNewFile *.rs setlocal textwidth=80
" }}}
" {{{ Functions
if !exists("*DmenuOpen")
  "" Open a file using my own dmenu-based file browser "dbrowse"
  function! DmenuOpen()
    let fname = system("dbrowse")
    if empty(fname)
      return
    endif
    " execute a:cmd . " " . fname
    execute "e " . fname
  endfunction

  "" Similarly, open a file in the current git repository.
  function! GitOpen()
    let fname = system("gitbrowse")
    if empty(fname)
      return
    endif
    execute "e " . fname
  endfunction
endif

function! OpenRandomFile()
  let fname = system("ls | sort -R | tail -1")
  if empty(fname)
    return
  endif
  execute "e " . fname
endfunction

" The .errorlines file consists of lines like "path/to/source_file.rs 123",
" created for example with my program `rust_error_lines`. So this function
" goes to the first or last error depending on `rev` and saves the list.
" NOTE vim has some feature called "quickfix list" that could maybe be used
" for the same purpose.
function! OpenFirstErrorLine(rev)
  let gitdir = finddir('.git/..', ';')
  let errorfile = gitdir . "/.errorlines"
  if !filereadable(errorfile)
    return
  endif

  let g:error_lines = split(system("cat " . errorfile), '\n')
  if empty(g:error_lines)
    return
  endif
  if a:rev
    call reverse(g:error_lines)
  endif
  let g:error_number = 0

  call OpenErrorLine(gitdir)
endfunction

" Given previous call to OpenFirstErrorLine(), go to next (or previous error).
function! OpenNextErrorLine(change)
  let gitdir = finddir('.git/..', ';')
  let errorfile = gitdir . "/.errorlines"
  let g:error_number = g:error_number + a:change
  call OpenErrorLine(gitdir)
endfunction

function! OpenErrorLine(gitdir)
  if g:error_number >= len(g:error_lines)
    return
  endif
  let line = g:error_lines[g:error_number]
  let fname = split(line, " ")
  execute "e " . a:gitdir . '/' . fname[0]
  execute fname[1]
endfunction

" `todo` is my program that scans for special todo comment lines and outputs
" them sorted by time. So this function goes to the line of the (nth) most recent
" todo.
" TODO Should probably work like the error line functions above.
function! OpenTodoLine(num)
  let gitdir = finddir('.git/..', ';')
  let line = system("todo | sed '" . a:num . "q;d'")
  if empty(line)
    return
  endif

  let tokens = split(line, " ")
  let source = split(tokens[1], ":")
  execute "e " . gitdir . '/' . source[0]
  execute source[1]
endfunction

" function StripTrailingWhitespace()
"   if !&binary && &filetype != 'diff'
"     normal mz
"     normal Hmy
"     %s/\s\+$//e
"     normal 'yz<CR>
"     normal `z
"   endif
" endfunction

" From <https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim>
function! s:entries(path) abort
  let path = substitute(a:path,'[\\/]$','','')
  let files = split(glob(path."/.*"),"\n")
  let files += split(glob(path."/*"),"\n")
  call map(files,'substitute(v:val,"[\\/]$","","")')
  call filter(files,'v:val !~# "[\\\\/]\\.\\.\\=$"')

  let filter_suffixes = substitute(escape(&suffixes, '~.*$^'), ',', '$\\|', 'g') .'$'
  call filter(files, 'v:val !~# filter_suffixes')

  return files
endfunction

" From <https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim>
function! s:FileByOffset(num) abort
  let file = expand('%:p')
  if empty(file)
    let file = getcwd() . '/'
  endif
  let num = a:num
  while num
    let files = s:entries(fnamemodify(file,':h'))
    if a:num < 0
      call reverse(sort(filter(files,'v:val <# file')))
    else
      call sort(filter(files,'v:val ># file'))
    endif
    let temp = get(files,0,'')
    if empty(temp)
      let file = fnamemodify(file,':h')
    else
      let file = temp
      let found = 1
      while isdirectory(file)
        let files = s:entries(file)
        if empty(files)
          let found = 0
          break
        endif
        let file = files[num > 0 ? 0 : -1]
      endwhile
      let num += (num > 0 ? -1 : 1) * found
    endif
  endwhile
  return file
endfunction

" From <https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim>
function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

" From <https://stackoverflow.com/a/27820229/13167227>:
"
" o/O                   Start insert mode with [count] blank lines.
"                       The default behavior repeats the insertion [count]
"                       times, which is not so useful.
function! s:NewLineInsertExpr(isUndoCount, command)
  if !v:count
    return a:command
  endif

  let l:reverse = { 'o': 'O', 'O' : 'o' }
  " First insert a temporary '$' marker at the next line (which is necessary
  " to keep the indent from the current line), then insert <count> empty lines
  " in between. Finally, go back to the previously inserted temporary '$' and
  " enter insert mode by substituting this character.
  " Note: <C-\><C-n> prevents a move back into insert mode when triggered via
  " |i_CTRL-O|.
  return (a:isUndoCount && v:count ? "\<C-\>\<C-n>" : '') .
  \   a:command . "$\<Esc>m`" .
  \   v:count . l:reverse[a:command] . "\<Esc>" .
  \   'g``"_s'
endfunction
nnoremap <silent> <expr> o <SID>NewLineInsertExpr(1, 'o')
nnoremap <silent> <expr> O <SID>NewLineInsertExpr(1, 'O')

" }}}
" {{{ Abbreviations
" Reminder that you can press <esc> after typing the abbreviation
" and have it expanded as you return to normal mode, to avoid typing
" a following character such as space.
function! RustAbbrev()
  iabbrev mutvec let mut vec = vec![];

  iabbrev derivex #[derive()]
  iabbrev derives #[derive(Clone, Copy, Debug, PartialEq)]
  iabbrev allowx #[allow(dead_code)]
  iabbrev attrx #[cfg_attr(test, derive(Clone))]
  iabbrev deprecatedx #[deprecated(note = "")]

  iabbrev formatx format!("{:?}", )
  iabbrev warnx warn!("{}: ", function!());
  iabbrev enume for (i, item) in data.iter().enumerate()
  iabbrev enumx <c-o>:read ~/.vim/templates/enum.rs<cr>
  iabbrev structx <c-o>:read ~/.vim/templates/struct.rs<cr>
  iabbrev defaultx <c-o>:read ~/.vim/templates/default.rs<cr>
  iabbrev iterx <c-o>:read ~/.vim/templates/iter.rs<cr>
  iabbrev iteratorx <c-o>:read ~/.vim/templates/iter.rs<cr>
  iabbrev matchx <c-o>:read ~/.vim/templates/match.rs<cr>
  iabbrev implx <c-o>:read ~/.vim/templates/impl.rs<cr>
  iabbrev fromx <c-o>:read ~/.vim/templates/from.rs<cr>
  iabbrev testx <c-o>:read ~/.vim/templates/test.rs<cr>
  iabbrev fnx <c-o>:read ~/.vim/templates/fn.rs<cr>
  iabbrev fnrng <c-o>:read ~/.vim/templates/fnrng.rs<cr>
endfunction
autocmd! Filetype rust call RustAbbrev()

function! CppAbbrev()
  iabbrev cout std::cout << << std::endl
  iabbrev printf printf("%\n");
  iabbrev logx log_debug("%");
  iabbrev forx for (size_t i = 0; i < ; ++i)
endfunction
autocmd! Filetype cpp,hpp call CppAbbrev()

" Insert text like '— Update `2019_06_07`'.
" nnoremap <F8> "=strftime('— Update `%Y_%m_%d`: ')<cr>p
" inoremap <F8> <Esc>"=strftime('— Update `%Y_%m_%d`: ')<cr>pa
iabbrev update! <C-r>=strftime('— Update `%Y_%m_%d`:')<cr>
iabbrev date! <C-r>=strftime('%Y_%m_%d')<cr>

function! EnableMathAbbrev()
  iabbrev grad ∇
  iabbrev nabla ∇

  iabbrev alpha α
  iabbrev nu ν
  iabbrev beta β
  iabbrev xi ξ
  iabbrev gamma γ
  " iabbrev omicron ο
  iabbrev delta δ
  iabbrev pi π
  iabbrev epsilon ε
  iabbrev rho ρ
  iabbrev zeta ζ
  iabbrev sigma σ
  iabbrev eta η
  iabbrev tau τ
  iabbrev theta θ
  " iabbrev upsilon υ
  " iabbrev iota ι
  iabbrev phi φ
  " iabbrev kappa κ
  iabbrev chi χ
  iabbrev lambda λ
  iabbrev psi ψ
  iabbrev mu μ
  iabbrev omega ω
  " iabbrev Alpha Α
  " iabbrev Nu Ν
  " iabbrev Beta Β
  iabbrev Xi Ξ
  iabbrev Gamma Γ
  " iabbrev Omicron Ο
  iabbrev Delta Δ
  iabbrev Pi Π
  " iabbrev Epsilon Ε
  " iabbrev Rho Ρ
  " iabbrev Zeta Ζ
  iabbrev Sigma Σ
  " iabbrev Eta Η
  " iabbrev Tau Τ
  " iabbrev Theta Θ
  " iabbrev Upsilon Υ
  " iabbrev Iota Ι
  iabbrev Phi Φ
  " iabbrev Kappa Κ
  " iabbrev Chi Χ
  iabbrev Lambda Λ
  iabbrev Psi Ψ
  " iabbrev Mu Μ
  iabbrev Omega Ω
endfunction
