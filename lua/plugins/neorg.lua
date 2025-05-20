return {
  "nvim-neorg/neorg",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/neorg/notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.concealer"] = {
          config = {},
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>o",
          },
        },
      },
    })
  end,
}
