return {
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {
        options = {
          diagnostics = 'nvim_lsp',
          show_close_icon = false,
          separator_style = 'thin',
          always_show_bufferline = true,
          offsets = {
            {
              filetype = 'neo-tree', -- Identifica o painel lateral
              text = 'File Explorer', -- Texto opcional exibido na barra
              text_align = 'left', -- Alinhamento do texto (esquerda/direita/centro)
              separator = true, -- Adiciona um separador visual
            },
          },
        },
      }
    end,
  },
}
