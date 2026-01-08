return {
  'Einenlum/yaml-revealer',
  config = function()
    -- Recommended for Neovim users
    vim.g.yaml_revealer_display_mode = 'virtual'
    vim.keymap.set('n', '<leader>ys', ':call SearchYamlKey()<CR>')
  end,
  ft = 'yaml',
}
