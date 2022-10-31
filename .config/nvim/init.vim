set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guicursor=

lua << END
require('lualine').setup {
  theme = 'tokyonight-moon',
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
