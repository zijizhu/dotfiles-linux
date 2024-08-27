return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        component_separators = '|',
        section_separators = ''
      },
      -- https://github.com/nvim-lualine/lualine.nvim/issues/271#issuecomment-1329925732
      sections = {
        lualine_c = { { 'filename', path = 1 } }
      }
    })
  end
}
