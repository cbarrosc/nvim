-- Override de render-markdown.nvim (LazyVim lo incluye via lang.markdown)
-- Solo opts: lazy.nvim los mergea con los de LazyVim y usa el config function original
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    checkbox = {
      enabled = true, -- LazyVim lo desactiva; lo reactivamos aquí
      unchecked = { icon = "󰝦 ", highlight = "RenderMarkdownUnchecked" }, -- pendiente
      checked   = { icon = "󰄲 ", highlight = "RenderMarkdownChecked" },   -- completada
      custom = {
        in_progress = { raw = "[>]", rendered = "󰔟 ", highlight = "RenderMarkdownInProgress" }, -- en progreso
        cancelled   = { raw = "[~]", rendered = "󰅙 ", highlight = "RenderMarkdownCancelled" },  -- cancelada
        important   = { raw = "[!]", rendered = "󰀦 ", highlight = "RenderMarkdownImportant" },  -- importante
      },
    },
  },
  -- init: registrar highlights antes de que cargue el colorscheme
  init = function()
    local function set_hl()
      vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked",  { fg = "#a6adc8" })           -- subtext0
      vim.api.nvim_set_hl(0, "RenderMarkdownChecked",    { fg = "#a6e3a1" })           -- green
      vim.api.nvim_set_hl(0, "RenderMarkdownInProgress", { fg = "#89b4fa", bold = true }) -- blue
      vim.api.nvim_set_hl(0, "RenderMarkdownCancelled",  { fg = "#7f849c" })           -- overlay1
      vim.api.nvim_set_hl(0, "RenderMarkdownImportant",  { fg = "#f38ba8", bold = true }) -- red
    end
    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
  end,
}
