-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<space>e', ':Neotree toggle<CR>', desc = 'Toggle NeoTree', silent = true },
    {
      '<space>1',
      function()
        -- Verificar se o buffer atual é o neo-tree
        local neo_tree_win = vim.fn.bufwinid 'Neo-tree filesystem [1]'
        if neo_tree_win ~= -1 then
          -- Fechar o painel do neo-tree
          vim.cmd 'wincmd p'
        else
          -- Focar no neo-tree
          vim.cmd 'Neotree focus'
        end
      end,
      desc = 'Toggle focus between NeoTree and code',
      silent = true,
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
