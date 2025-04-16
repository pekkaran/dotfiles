-- Configuration for nvim.

-- lazy.nvim plugin manager setup (you don't have to clone any repositories manually).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Must set maploaders before lazy.nvim setup().
vim.g.mapleader = ","

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Load everything in `lua/plugins/`
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")

        on_attach = function(client, bufnr)
          -- Without this seems to change editor colors weirdly.
          client.server_capabilities.semanticTokensProvider = nil
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "<leader>j", vim.lsp.buf.definition, "Go to definition")
          map("n", "<leader>u", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "<leader>i", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "<leader>r", vim.lsp.buf.rename, "Rename symbol")
          map('n', '<leader>w', vim.diagnostic.open_float, "Show warning popup")
          -- map("n", "gr", vim.lsp.buf.references, "List references")
          -- map("n", "<leader>o",  vim.lsp.buf.hover, "Show hover info")
          -- map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
          -- map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        end

        lspconfig.rust_analyzer.setup({ on_attach = on_attach })
        lspconfig.clangd.setup({
          cmd = { "clangd", "--background-index", "--compile-commands-dir=target" },
          on_attach = on_attach,
        })
      end
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd("colorscheme tokyonight-moon")
      end,
    },
    { "eugen0329/vim-esearch" },
    { "editorconfig/editorconfig-vim" },
    { "tikhomirov/vim-glsl" },
    { "nvim-lualine/lualine.nvim" },
    -- { "ervandew/supertab" },
    { "tpope/vim-abolish" },
    { "tomtom/tcomment_vim" },
    -- NOTE Need both `fzf` and `fzf-lua`, but not to install a system package for `fzf`(?).
    { "junegunn/fzf" },
    {
      "ibhagwan/fzf-lua",
      config = function() require("fzf-lua").setup({
        winopts = {
          fullscreen = true,
          border = "single",
          preview = {
            horizontal = 'right:50%',
            winopts = {
              number = false,
              cursorline = false,
            },
          },
        }
      }) end
    },
  },
})

vim.opt.backup = false
vim.opt.swapfile = false
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
vim.opt.matchpairs:append("<:>") -- Also match < > with %.
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.shortmess:append("I") -- Disable welcome message when starting vim without a file argument.
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
vim.opt.clipboard:append("unnamedplus") -- Yanks and deletes additionally go to the + register, so you can paste them with ctrl-v.
vim.opt.breakindent = true -- Show soft-wrapped text with leading indent.
vim.opt.undolevels = 1000 -- Remember this many changes.
vim.opt.mouse = "" -- Disable mouse support.
-- The tags filename is non-default ".tags", and the rest of the string ";/" makes vim search a tags file from all parent directories until one is found.
vim.opt.tags = ".tags;/"
-- Indenting. Plugins like `editorconfig` will override these.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth when using < and >.
vim.opt.smarttab = true -- Insert blanks according to shiftwidth.

vim.g.netrw_browse_split = 4 -- When opening a file from netrw split, show it in the original split.

vim.o.signcolumn = "no"

-- C/C++ formatoptions
vim.opt.formatoptions:append("2") -- Use paragraph second line indent
vim.opt.formatoptions:append("1") -- Try not to break lines after one letter words. For stuff like 'I think' or 'a thing'?
vim.opt.formatoptions:append("c") -- Auto-wrap comments at textwidth
vim.opt.formatoptions:append("j") -- Merge comments when joining lines
vim.opt.formatoptions:append("q") -- Allow formatting comments with `gq`
vim.opt.formatoptions:append("r") -- Insert comment leader after <enter> in insert mode
vim.opt.formatoptions:append("t") -- Auto-wrap at textwidth
vim.opt.formatoptions:remove("a") -- Disable automatic formatting of paragraphs
vim.opt.formatoptions:remove("l") -- Format long lines when inserting
vim.opt.formatoptions:append("o") -- Automatically insert comment on `o`…
vim.opt.formatoptions:append("/") -- … except when the comment comes after a statement.

local aucmd = vim.api.nvim_create_autocmd
local function augroup(name, f)
  f(vim.api.nvim_create_augroup(name, { clear = true }))
end

-- Show tabs and trailing whitespace but don't show trailing whitespace in insert mode.
-- Apparently need to set the whole table at once(?).
vim.opt.list = true
local listchars_normal = { tab = '--', trail = '-', nbsp = '-', extends = '#' }
local listchars_insert = { tab = '--', trail = ' ', nbsp = '-', extends = '#' }
vim.opt.listchars = listchars_normal

augroup('Listchars', function(g)
  aucmd('InsertEnter', {
    group = g,
    callback = function() vim.opt.listchars = listchars_insert end
  })
  aucmd('InsertLeave', {
    group = g,
    callback = function() vim.opt.listchars = listchars_normal end
  })
end)

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

augroup('CustomSyntax', function(g)
  aucmd({ "BufNewFile", "BufRead" }, {
    group = g,
    callback = function()
      -- The JSON syntax highlighter does not actually support JSONL, but works well enough.
      if vim.bo.filetype == "jsonl" then
        vim.opt.syntax = "json"
      end
    end
  })
  aucmd("BufRead", {
    pattern = "*.tags",
    group = g,
    callback = function() vim.opt.syntax = "tags" end
  })
end)

-- TODO Limit git commit second paragraph width
-- autocmd Filetype gitcommit setlocal spell textwidth=72

-- Only show cursorline in the current window and in normal mode
augroup('Cursorline', function(g)
  aucmd({ "WinLeave", "InsertEnter" }, {
    group = g,
    callback = function() vim.opt.cursorline = false end
  })
  aucmd({ "WinEnter", "InsertLeave" }, {
    group = g,
    callback = function() vim.opt.cursorline = true end
  })
end)

local vim_default_path = vim.o.path
augroup('AutoCd', function(g)
  aucmd("BufEnter", {
    group = g,
    callback = function()
      -- Automatically cd into the directory that the file is in.
      local current_file_path = vim.fn.expand("%:p:h")
      local escaped_path = vim.fn.escape(current_file_path, ' \\/.*$^~[]#')
      vim.cmd("chdir " .. escaped_path)

      -- Add git project root to path. This allows for easier finding with vim.
      local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
      local git_root = handle:read("*a")
      handle:close()
      -- Need to use `vim_default_path` or else the path will grow every time switching buffers.
      vim.o.path = vim_default_path .. "," .. git_root:gsub("%z", ""):gsub("\n", "")
    end
  })
end)

local map_args = { noremap = true, silent = true }

local function clearJunk()
  -- Delete all `esearch` buffers.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match("Search ‹") then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  -- Delete all `netrw` buffers.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    if filetype == "netrw" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  -- Clear various visual effects.
  vim.cmd.nohl()
  -- vim.cmd.cexpr()
  vim.cmd.cclose()
  vim.cmd.echo()
end
vim.keymap.set("n", "<space>", clearJunk, map_args)

-- TODO Not sure if all of this works the same way in nvim.
-- " Copy and paste.
-- "
-- "Vim offers the + and * registers to reference the system clipboard (:help quoteplus and :help quotestar). Note that on some systems, + and * are the same, while on others they are different. Generally on Linux, + and * are different: + corresponds to the desktop clipboard (XA_SECONDARY) that is accessed using CTRL-C, CTRL-X, and CTRL-V, while * corresponds to the X11 primary selection (XA_PRIMARY), which stores the mouse selection and is pasted using the middle mouse button in most applications.
-- "
-- " NOTE that these (the * and + registers) do not work without a clipboard
-- " tool vim can work with, for example `xclip`. See :help clipboard for
-- " details.
-- nnoremap <leader>y "+y
-- nnoremap <leader>p "+p
-- nnoremap <leader>P "+P
-- vnoremap <leader>y "+ygv
-- " vnoremap <C-c> "+yi
-- " vnoremap <C-x> "+c
-- " vnoremap <C-v> c<ESC>"+p
-- inoremap <C-v> <C-r><C-o>+

-- To quickly go to line 42, type '42,,'
vim.keymap.set("n", "<leader><leader>", "Gzz", map_args)

-- Add todo note for a search program. `gcc` comments the line, and `==` indents it.
-- TODO syntax issue
-- vim.keymap.set("n", "<leader>t", 'O<esc>"=strftime('TODO STACK %Y_%m_%d-%T')<cr>pgcc==",

-- Open netrw split on the right side.
vim.keymap.set("n", "<leader>n", ":Vexplore!<cr>", map_args)

local function set_keymaps_help()
  -- Follow links and go back in help pages
  vim.keymap.set("n", "<return>", "<C-]>", map_args)
  vim.keymap.set("n", "<backspace>", "<C-T>", map_args)
end

local function set_keymaps_other()
  -- Tags (eg ctags):
  -- Go to definition under cursor.
  vim.keymap.set("n", "<leader>j", "<C-]>", map_args)
  vim.keymap.set("n", "<C-]>", "<nop>", map_args)
  -- Go back to previous location after <C-]>.
  vim.keymap.set("n", "<leader>k", "<C-t>", map_args)
  -- Next definition of last tag.
  vim.keymap.set("n", "<leader>u", ":tn<cr>", map_args)
  -- List definitons of last tag.
  vim.keymap.set("n", "<leader>l", ":ts<cr>", map_args)
end

augroup('FileTypeKeymaps', function(g)
  aucmd('FileType', {
    group = g,
    callback = function()
      if vim.bo.filetype == "rust" then
        -- pass
      elseif vim.bo.filetype == "help" then
        set_keymaps_help()
      else
        set_keymaps_other()
      end
    end
  })
end)

-- Own functions, defined later.
vim.keymap.set("n", "<leader>e", ":call OpenFirstErrorLine(1)<cr>", map_args)
vim.keymap.set("n", "<leader>E", ":call OpenFirstErrorLine(0)<cr>", map_args)
vim.keymap.set("n", "<leader>w", ":call OpenNextErrorLine(1)<cr>", map_args)
vim.keymap.set("n", "<leader>W", ":call OpenNextErrorLine(-1)<cr>", map_args)

-- vim-abolish plugin:
-- Swap boolean values in selection or current line.
vim.keymap.set("v", "<leader>b", ":Subvert/{true,false}/{false,true}<cr>:nohl<cr>", map_args)
vim.keymap.set("n", "<leader>b", ":.Subvert/{true,false}/{false,true}<cr>:nohl<cr>", map_args)
-- Some abbreviations I use produce template code with placeholder variables like `Xx`.
vim.keymap.set("v", "<leader>2", ":Subvert/{Xx,Yy}/{", map_args)
vim.keymap.set("n", "<leader>2", ":.Subvert/{Xx,Yy}/{", map_args)

vim.keymap.set("n", "<F1>", "<nop>", map_args)

-- Edit previous and next file by alphabetical sort.
-- From <https://github.com/tpope/vim-unimpaired/blob/master/plugin/unimpaired.vim>
-- nnoremap <silent> mm :<C-U>edit <C-R>=<SID>fnameescape(fnamemodify(<SID>FileByOffset(v:count1), ':.'))<CR><CR>
-- nnoremap <silent> <F9> :<C-U>edit <C-R>=<SID>fnameescape(fnamemodify(<SID>FileByOffset(-v:count1), ':.'))<CR><CR>

-- These days vim can paste things without paste mode, but it's occasionally
-- useful for typing things without interference from `imap`s.
-- set pastetoggle=<F10>

-- Can't map unmodified F11?
vim.keymap.set("n", "<S-F11>", ":call OpenRandomFile()<cr>", map_args)

-- Switch between source and header files. Very crude, only works for the
-- extension pairs cpp-hpp and c-h.
vim.keymap.set("n", "<leader>z", ":e %:p:s,.hpp$,.XHPPX,:s,.h$,.XHX,:s,.cpp$,.hpp,:s,.c$,.h,:s,.XHPPX$,.cpp,:s,.XHX$,.c,<cr>", map_args)

-- Normally `gf` opens file with the name under cursor, but that file must exist.
-- This remapping also opens a new file. Note you still need to save the new file.
vim.keymap.set("n", "gf", ":e <cfile><cr>", map_args)

-- Multi-character insert mode combinations.
-- Requiring a timeout, these interfere with typing somewhat,
-- so only start them with 'j' to minimize the effects.

vim.keymap.set("i", "jk", "<esc>", map_args)
vim.keymap.set("i", "Jk", "<esc>", map_args)
vim.keymap.set("i", "JK", "<esc>", map_args)
vim.keymap.set("i", "jjk", "<esc>", map_args)
-- vim.keymap.set("i", "<esc>", "<nop>", map_args)
-- New line in insert mode.
vim.keymap.set("i", "<cr>", "<nop>", map_args)
vim.keymap.set("i", "<C-l>", "<C-j>", map_args)
vim.keymap.set("n", "<C-l>", "o", map_args)
vim.keymap.set("i", "jf", "<C-j>", map_args)

-- Quick save.
vim.keymap.set("n", "<leader>m", ":w<cr>", map_args)

-- Should use <c-h>. Be aware also of <c-w> and <c-u> which delete back word
-- or the entire line.
vim.keymap.set("i", "<backspace>", "<nop>", map_args)

-- Normally this cycles between normal-insert-replace modes.
vim.keymap.set("i", "<insert>", "<nop>", map_args)
vim.keymap.set("n", "<insert>", "<nop>", map_args)
vim.keymap.set("v", "<insert>", "<nop>", map_args)

-- Do not use 'select mode'.
vim.keymap.set("v", "<C-g>", "<nop>", map_args)

-- Colon commands are common so put them behind the easier to type '.' and
-- remap the repeat/repetition key. `\` is normally the leader key.
-- vim.keymap.set("n", ":", "<nop>", map_args) -- Setting these to <nop> breaks abbreviations that use `:`.
-- vim.keymap.set("v", ":", "<nop>", map_args)
vim.keymap.set("n", ".", ":", { noremap = true })
vim.keymap.set("v", ".", ":", { noremap = true })
vim.keymap.set("n", "\\", ".", map_args)
vim.keymap.set("v", "\\", ".", map_args)

-- Use one pinky finger instead of two for the register key.
vim.keymap.set("n", ";", '"', map_args)
vim.keymap.set("v", ";", '"', map_args)

-- The black hole register. Prefix delete commands with this to not yank them
vim.keymap.set("n", ";;", '"_', map_args)
vim.keymap.set("v", ";;", '"_', map_args)

-- System clipboard register (the one I use).
vim.keymap.set("n", ";p", '"+', map_args)

-- By default ^ returns to the first non-whitespace character and 0 to the
-- first character. Remapped because of how I happened to learn use one before
-- the other. Mnemonic: # is left of $, and how in C/C++ `#macros` are often
-- idented to the first column.
vim.keymap.set("n", "0", "^", map_args)
vim.keymap.set("n", "#", "0", map_args)
vim.keymap.set("n", "^", "<nop>", map_args)

vim.keymap.set("n", "s", "<nop>", map_args) -- Weird/useless command, avoid triggering by accident.

-- Don't move on *, which searches for the word under cursor.
local function star()
  local view = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(view)
end
vim.keymap.set('n', '*', star, map_args)

-- By default q is the macro recording key. Hard to exit when you press it by accident.
vim.keymap.set("n", "+", "q", map_args)
vim.keymap.set("n", "q", "<nop>", map_args)

-- Kind of like the opposite of `J`, this command splits lines on space.
-- By default K opens man page for word under cursor.
vim.keymap.set("n", "K", "i<return><esc>", map_args)

-- Often I want to yank text in visual mode, but accidentally hitting `u` instead of `y`.
vim.keymap.set("v", "u", "<nop>", map_args)

-- Disable backwards search. It's more intuitive to always search forward
-- and then cycle the matches forwards (`n`) or backwards (`N`).
vim.keymap.set("n", "?", "<nop>", map_args)

-- Never put single deleted characters into the unnamed register.
vim.keymap.set("n", "x", '"_x', map_args)
vim.keymap.set("n", "X", '"_X', map_args)

-- Delete [count] lines without putting them in the unnamed register. Useful for empty lines.
-- Disabled because I actually wanted to use the original command ("delete to").
-- vim.keymap.set("n", "df", '"_dd', map_args)

-- Paste the last yanked text, ignoring the deleted stuff that goes in the unnamed register.
-- vim.keymap.set("n", "cp", '"0p', map_args)

-- Previous, next and close buffer.
vim.keymap.set("n", "H", vim.cmd.bprev, map_args)
vim.keymap.set("n", "L", vim.cmd.bnext, map_args)
vim.keymap.set("n", "Q", vim.cmd.bdelete, map_args)

-- Keep the cursor in place while joining lines
vim.keymap.set("n", "J", "mzJ`z", map_args)

-- Generate curly brackets block and leave in insert mode inside. Could be more
-- robust. I have mapped to keys like ¹²³ from alt-123….
vim.keymap.set("n", "¹",      [[:.s/\s\+$//e<cr>:nohl<cr>A {<return>}<esc>O]], map_args)
vim.keymap.set("i", "¹", [[<esc>:.s/\s\+$//e<cr>:nohl<cr>A {<return>}<esc>O]], map_args)
-- Rust `match` block.
vim.keymap.set("n", "²",      [[:.s/\s\+$//e<cr>:nohl<cr>A => {<return>},<esc>O]], map_args)
vim.keymap.set("i", "²", [[<esc>:.s/\s\+$//e<cr>:nohl<cr>A => {<return>},<esc>O]], map_args)

-- Normally <C-o> allows executing normal mode commands from insert mode, but I use <C-o> for
-- opening files.
-- vim.keymap.set("i", "<C-i>", "<C-o>", map_args)

-- Move individual lines up and down. I use this all the time. Especially handy
-- with `J` (join) and `K` (split; a custom command defined in this file).
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", map_args)
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", map_args)
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", map_args)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", map_args)
vim.keymap.set("i", "<C-j>", "<nop>", map_args)
vim.keymap.set("i", "<C-k>", "<nop>", map_args)

-- Grep-like search plugin.
vim.keymap.set("n", "<C-f>", "<plug>(esearch)", map_args)

-- Substitute text.
vim.keymap.set("n", "<C-e>", ":%s/", map_args)
vim.keymap.set("v", "<C-e>", ":s/", map_args)
vim.keymap.set("n", "<C-s>", ":%Subvert/", map_args)
vim.keymap.set("v", "<C-s>", ":Subvert/", map_args)

-- Shows a UI to open a file from the current git repository, where
-- the selection is made by fuzzy finding on the file names.
vim.keymap.set("n", "<C-o>", ":FzfLua git_files --others --exclude-standard --cached<cr>", map_args)

-- Toggle line numbers.
vim.keymap.set("n", "<C-n>", ":setlocal number!<cr>", map_args)

-- Center after search.
vim.keymap.set("n", "n", "nzz", map_args)
vim.keymap.set("n", "N", "Nzz", map_args)

vim.keymap.set("n", "<leader>k", "<C-o>", { desc = "Go back (from definition)" })

-- Tab-complete keys
-- local nrt = function(str)
--     return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end
--
-- local check_back_space = function()
--   local col = vim.fn.col('.') - 1
--   return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
-- end
--
-- _G.tab_complete = function()
--   if vim.fn.pumvisible() == 1 then
--     return nrt "<C-n>"
--   elseif check_back_space() then
--     return nrt "<Tab>"
--   -- else
--   --   vim.fn["coc#refresh"]()
--   end
-- end
--
-- _G.s_tab_complete = function()
--   if vim.fn.pumvisible() == 1 then
--     return nrt "<C-p>"
--   else
--     return nrt "<C-h>"
--   end
-- end
--
-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- When yanking text, briefly highlight in color the region that was copied.
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 500 }
  end,
})

-- Plugins

require('lualine').setup {
  theme = 'tokyonight-moon',
  options = {
    -- Fits more filenames.
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_b = { 'branch' }, -- removed diff and diagnostics
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

vim.cmd[[

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

]] -- vim.cmd

augroup('Abbreviations', function(g)
  aucmd('FileType', {
    group = g,
    callback = function()
      if vim.bo.filetype == "rust" then
        vim.cmd[[
          iabbrev mutvec let mut vec = vec![];

          iabbrev debugx #[cfg(debug_assertions)]
          iabbrev derivex #[derive()]
          iabbrev derives #[derive(Clone, Copy, Debug, PartialEq)]
          iabbrev allowx #[allow(dead_code, unused_variables, unused_mut)]
          iabbrev attrx #[cfg_attr(test, derive(Clone))]
          iabbrev deprecatedx #[deprecated(note = "")]
          iabbrev forx for i in 0...len()
          iabbrev clippyx #![allow(clippy::clone_on_copy)]
          iabbrev contextx .with_context(fformat!("to_do_something."))?

          iabbrev formatx format!("{:?}", )
          iabbrev warnx warn!("{}: ", function!());
          iabbrev enume for (i, item) in data.iter().enumerate()
          iabbrev enumx <esc>:read ~/dotfiles/code-templates/rust/enum.rs<cr>
          iabbrev defaultx <esc>:read ~/dotfiles/code-templates/rust/default.rs<cr>
          iabbrev iterx <esc>:read ~/dotfiles/code-templates/rust/iter.rs<cr>
          iabbrev iteratorx <esc>:read ~/dotfiles/code-templates/rust/iter.rs<cr>
          iabbrev matchx <esc>:read ~/dotfiles/code-templates/rust/match.rs<cr>
          iabbrev implx <esc>:read ~/dotfiles/code-templates/rust/impl.rs<cr>
          iabbrev fromx <esc>:read ~/dotfiles/code-templates/rust/from.rs<cr>
          iabbrev testx <esc>:read ~/dotfiles/code-templates/rust/test.rs<cr>

          " Override /usr/share/nvim/runtime/indent/rust.vim
          " Try removing after neovim 0.10 release.
          set cinoptions=l1,g0,+s,N-s,E-s,(s,k2s,U1,m1
        ]]
      elseif vim.bo.filetype == "cpp" or vim.bo.filetype == "hpp" then
        vim.cmd[[
          iabbrev cout std::cout << << std::endl
          iabbrev printf printf("%\n");
          iabbrev logx log_debug("%");
          iabbrev warnx log_warn("%");
          iabbrev forx for (size_t i = 0; i < ; ++i)
          iabbrev forax for (const auto &y : ys)
          iabbrev forsx for (const std::string &y : ys)
          iabbrev infx std::numeric_limits<float>::infinity()
          iabbrev infinityx std::numeric_limits<float>::infinity()
        ]]
      elseif vim.bo.filetype == "python" then
        vim.cmd[[
          iabbrev mainx <c-o>:read ~/dotfiles/code-templates/python/main.py<cr>
          iabbrev csvx <c-o>:read ~/dotfiles/code-templates/python/readCsv.py<cr>
          iabbrev jsonx <c-o>:read ~/dotfiles/code-templates/python/readJson.py<cr>
          iabbrev jsonlx <c-o>:read ~/dotfiles/code-templates/python/readJson.py<cr>
          iabbrev walkx <c-o>:read ~/dotfiles/code-templates/python/walk.py<cr>
          iabbrev slurpx <c-o>:read ~/dotfiles/code-templates/python/slurp.py<cr>
        ]]
      else
        vim.cmd[[
          iabbrev update! <C-r>=strftime('— Update `%Y_%m_%d`:')<cr>
        ]]
      end
    end
  })
end)

-- Experimental. Default to markdown.
vim.cmd [[
  augroup MarkdownFallback
    autocmd!
    autocmd BufRead,BufNewFile * if &ft == '' | set filetype=markdown | endif
  augroup END
]]

aucmd("FileType", {
  pattern = "txt",
  callback = function()
    vim.opt_local.commentstring = "//%s"
  end,
})

-- List of remaining plugins I previously used via pathogen.
-- vim-cpp-modern
-- vim-localrc
