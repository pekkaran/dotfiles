-- Configuration for nvim.

-- TODO no need to set these?
--filetype detect
--filetype on
--filetype plugin on
--filetype plugin indent on
-- vim.opt.noerrorbells = true
-- vim.opt.noswapfile = true
-- vim.opt.nobackup = true

-- lazy.nvim plugin manager setup.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Must set maploaders before lazy.nvim setup().
vim.g.mapleader = ","

-- <https://github.com/folke/tokyonight.nvim>
require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      'nvim-lualine/lualine.nvim',
    }
  },
})
vim.cmd[[colorscheme tokyonight-moon]]

-- TODO Not tested properly, attempting to use normal vim plugins via pathogen.
-- If "infect" fails, make sure (using symlinks) that the pathogen file is in this exact path:
--   ~/.config/nvim/autoload/pathogen.vim
local execute = vim.api.nvim_command
execute('runtime autoload/pathogen.vim')
execute('call pathogen#infect()')

vim.opt.guicursor = "" -- Show block cursor also in insert mode.
vim.opt.number = true
vim.opt.incsearch = true -- Search while typing.
vim.opt.ignorecase = true -- Ignore case in search …
vim.opt.smartcase = true -- … unless it's upper.
vim.opt.hlsearch = true
vim.opt.title = true
vim.opt.showcmd = true -- Show command information.
vim.opt.cursorline = true -- Enable cursor highlight.
vim.opt.timeoutlen = 1000 -- Timeout in milliseconds for leader commands and combos (e.g. the common 'jk' -> Esc).
vim.opt.ruler = false
vim.opt.laststatus = 2
vim.opt.modeline = false
vim.opt.modelines = 0
vim.opt.backspace = indent,eol,start -- Backspace behaviour (indent -> eol -> start)--
vim.opt.tabpagemax = 20 -- How many tabs can be opened with -p command.
vim.opt.showmode = false -- Do not show stuff on the status line because we have the airline plugin.
vim.opt.showtabline = 2
vim.opt.scrolloff = 10 -- Minimum number of lines to always show below and above cursor.
vim.opt.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
-- vim.opt.matchpairs+=<:> -- Also match < > with %. TODO lua
vim.opt.hidden = true
vim.opt.confirm = true
-- vim.opt.shortmess+=I -- Disable welcome message when starting vim without a file argument. TODO lua
vim.opt.gdefault = true -- Make `s///` behave like `s///g` and vice versa.
vim.opt.splitbelow = true -- New split placement.
vim.opt.splitright = true
-- uhex:     Show unprintable chars as <xx> instead of ^C.
-- lastline: Do no replace partially visible wrapped lines with
--           stacks of '@' symbols.
vim.opt.display = uhex,lastline
vim.opt.wrap = true -- Wrap lines that don't fit to screen …
vim.opt.linebreak = true -- … but only wrap at characters listed in `breakat`.
vim.opt.virtualedit = block -- Free block placement in visual mode
vim.opt.joinspaces = false -- When joining to line that ends in period, do not insert two spaces.
-- vim.opt.clipboard += unnamedplus -- Yanks and deletes additionally go to the + register, so you can paste them with ctrl-v. TODO lua
vim.opt.breakindent = true -- Show soft-wrapped text with leading indent.
vim.opt.undolevels = 1000 -- Remember this many changes.
vim.opt.mouse = "" -- Disable mouse support.
vim.opt.tags = ".tags" -- filename for ctags file
-- au BufReadPost .tags vim.opt.syntax=tags -- TODO lua
-- Indenting. Plugins like `editorconfig` will override these.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth when using < and >.
vim.opt.smarttab = true -- Insert blanks according to shiftwidth.

-- TODO formatoptions, don't know how to manipulate lua lists…

-- TODO bunch of other options in this section of the old .vimrc

-- Show tabs and trailing whitespace …
vim.opt.list = true
vim.opt.listchars = "tab:--,trail:-,extends:#,nbsp:-"
-- … but don't show trailing whitespace in insert mode.
-- augroup trailing
--   au!
--   au InsertEnter * :set listchars-=trail:-
--   au InsertLeave * :set listchars+=trail:-
-- augroup END


-- Visual autocomplete for command menu.
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list,full"
-- From sjl:
-- set wildignore+=.hg,.git,.svn                    -- Version control
-- set wildignore+=*.aux,*.out,*.toc                -- LaTeX intermediate files
-- set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   -- binary images
-- set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest -- compiled object files
-- set wildignore+=*.DS_Store                       -- OSX bullshit

-- Don't try to highlight lines longer than this many characters.
vim.opt.synmaxcol = 600

-- Language of vim.
vim.opt.helplang = en
vim.opt.langmenu = en

-- vim.opt.indentation rules for C/C++ programs.
vim.opt.cinoptions = "l1,g0,+s,N-s,E-s,(s,k2s,U1,m1"

-- Some movement commands like C-d, G, and :<num> place cursor on first non-blank character.
vim.opt.startofline = true

-- Language/encoding of edited files.
-- set encoding=utf-8
-- Failing to open a file using default encodings, test all the Japanese
-- encodings supported by vim (for list, see :help mbyte-encoding).
-- If you come across a file with undetected coding, try
-- running `file <file>` for a clue what to add to this list.
vim.opt.fileencodings = "ucs-bom,utf-8,default,latin1,iso-2022-jp,euc-jp,sjis,cp932"
-- TODO The above doesn't seem to work. I was able to read a `sjis` file with
-- `:e ++enc=sjis` after opening the file.

-- The JSON syntax highlighter does not support JSONL, but works well enough
-- since we rarely intend to edit JSONL files, just view them.
-- augroup jsonl
--   au!
--   autocmd BufNewFile,BufRead *.jsonl set syntax=json
-- augroup END

-- Skipped folding stuff from .vimrc.

-- TODO Limit git commit second paragraph width
-- autocmd Filetype gitcommit setlocal spell textwidth=72

-- TODO Add git project root to path. This allows for easier finding with vim.
-- The substitution removes terminating null character.
-- Nothing bad happens if the git rev-parse fails outside a git repository.
-- let s:cdg = substitute(system(--git rev-parse --show-toplevel--), '\%x00', '', 'g')
-- let &path = &path.','.s:cdg

-- TODO Only show cursorline in the current window and in normal mode
-- augroup cline
--   au!
--   au WinLeave,InsertEnter * set nocursorline
--   au WinEnter,InsertLeave * set cursorline
-- augroup END

-- TODO Automatically cd into the directory that the file is in
-- autocmd BufEnter * execute --chdir --.escape(expand(--%:p:h--), ' \\/.*$^~[]#')

-- TODO Space "reset" function.
-- nnoremap <silent> <space> mz:nohl<cr> :call DeleteEsearch()<cr> :call CloseNetrw()<cr> :call Reset()<cr>`z

--[[ TODO Not sure if all of this works the same way in nvim.
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
--]]

-- To quickly go to line 42, type '42,,'
vim.api.nvim_set_keymap("n", "<leader><leader>", "Gzz", { noremap = true, silent = true })

-- TODO skipped over a lot of mappings

-- Previous, next and close buffer.
vim.api.nvim_set_keymap("n", "H", ":bp<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "L", ":bn<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "Q", ":bd<cr>", { noremap = true, silent = true })

-- Keep the cursor in place while joining lines
vim.api.nvim_set_keymap("n", "J", "mzJ`z", { noremap = true, silent = true })

-- Plugins

require('lualine').setup {
  theme = 'tokyonight-moon',
  options = {
    -- Fits more filenames.
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_b = {'branch'}, -- removed diff and diagnostics
    lualine_c = {
      {
        'filename',
        newfile_status = true,
        path = 3
      }
    }
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        max_length = vim.o.columns, -- Without this only about 50% of the available space will be used.
        symbols = {
          modified = '*',
          alternate_file = '',
          directory = ''
        }
      }
    },
  }
}
