-- config/python.lua

-- Autoactivar venv al abrir archivos .py
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  callback = function()
    local venv_dir = vim.fn.finddir("venv", ".;")
    if venv_dir ~= "" then
      local python_path = vim.fn.getcwd() .. "/" .. venv_dir .. "/bin/python"
      vim.g.python3_host_prog = python_path
      vim.cmd("echo '🐍 Virtualenv activado: " .. python_path .. "'")
    end
  end,
})

-- Ejecutar el archivo actual con el venv si existe
vim.keymap.set("n", "<leader>rr", function()
  local cwd = vim.fn.getcwd()
  local venv_python = cwd .. "/venv/bin/python"
  local fallback = "python"
  local file = vim.fn.expand("%")
  local python_exec = vim.fn.filereadable(venv_python) == 1 and venv_python or fallback

  -- Abrir la terminal flotante estilo <leader>ft
  require("lazyvim.util").terminal(nil, { cwd = require("lazyvim.util").root() })

  -- Enviar el comando dentro de la terminal
  -- Usamos un pequeño retardo para asegurar que la terminal esté lista
  vim.defer_fn(function()
    vim.fn.chansend(vim.b.terminal_job_id, python_exec .. " " .. file .. "\n")
  end, 100)
end, { desc = "Ejecutar script Python en terminal flotante (venv)" })
