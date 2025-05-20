-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>nn", ":e ~/neorg/notes/index.norg<CR>", { desc = "Neorg: Abrir index" })

vim.keymap.set("n", "<leader>tm", function()
  local buftype = vim.bo.buftype
  if buftype ~= "" then
    vim.notify("Este buffer no es modificable", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_get_current_line()
  local task_states = {
    [" "] = "[ ] pendiente",
    ["x"] = "[x] completada",
    [">"] = "[>] en progreso",
    ["!"] = "[!] importante",
    ["c"] = "[c] cancelada",
  }

  vim.ui.select(vim.tbl_keys(task_states), {
    prompt = "Selecciona nuevo estado de tarea:",
    format_item = function(item)
      return task_states[item]
    end,
  }, function(choice)
    if not choice then
      return
    end
    -- Reemplaza cualquier estado existente con el nuevo
    local updated = line:gsub("%- %[.]", "- [" .. choice .. "]", 1)
    vim.api.nvim_set_current_line(updated)
    vim.notify("Tarea marcada como: " .. task_states[choice])
  end)
end, { desc = "Neorg: Cambiar estado de tarea" })
