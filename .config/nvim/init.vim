set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guicursor=

lua << END
require('lualine').setup {
  theme = 'tokyonight-moon',
  sections = {
    lualine_c = {
      {
        'filename',
        newfile_status = true,
        path = 3
        -- shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
        -- symbols = {
        --   modified = '[+]',      -- Text to show when the file is modified.
        --   readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        --   unnamed = '[No Name]', -- Text to show for unnamed buffers.
        --   newfile = '[New]',     -- Text to show for new created file before first writting
        -- }
      }
    }
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        symbols = {
          modified = '*',
          alternate_file = '',
          directory = ''
        }
      }
    },
    lualine_z = {'tabs'}
  }
}
END
