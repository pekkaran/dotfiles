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
