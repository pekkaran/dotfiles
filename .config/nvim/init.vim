set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guicursor=

lua << END
require('lualine').setup {
  theme = 'tokyonight-moon',
  options = {
    -- Fits more filenames and works without powerline fonts.
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
END
