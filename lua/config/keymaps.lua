-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local vim = vim

-- Abrir el índice de Neorg
vim.keymap.set("n", "<leader>nn", ":e ~/neorg/notes/index.norg<CR>", { desc = "Neorg: Abrir index" })

-- Cambiar el estado de una tarea Neorg
vim.keymap.set("n", "<leader>nt", function()
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
    local updated = line:gsub("%- %[.]", "- [" .. choice .. "]", 1)
    vim.api.nvim_set_current_line(updated)
    vim.notify("Tarea marcada como: " .. task_states[choice])
  end)
end, { desc = "Neorg: Cambiar estado de tarea" })

-- Crear una nueva nota Neorg
vim.keymap.set("n", "<leader>na", function()
  local notes_dir = vim.fn.expand("~/neorg/notes/")
  vim.ui.input({ prompt = "Nombre de la nueva nota (usa / para carpetas): " }, function(input)
    if not input or input == "" then
      vim.notify("Nombre inválido", vim.log.levels.WARN)
      return
    end

    local full_path = notes_dir .. "/" .. input .. ".norg"
    vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p") -- crear carpetas necesarias
    vim.cmd("edit " .. full_path)
    vim.notify("Nota creada en: " .. full_path)
  end)
end, { desc = "Neorg: Crear nueva nota" })
