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

-- Ejecutar el archivo actual con el venv si existe y copiar PNR al clipboard
vim.keymap.set("n", "<leader>rr", function()
  local file = vim.fn.expand("%")
  local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
  local python_exec = vim.fn.filereadable(venv_python) == 1 and venv_python or "python"

  local terminal = Snacks.terminal.open(
    { python_exec, file },
    { cwd = LazyVim.root(), auto_close = false }
  )

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = terminal.buf,
    once = true,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(terminal.buf, 0, -1, false)
      for i = #lines, 1, -1 do
        local pnr = lines[i]:match("^PNR=(%S+)$")
        if pnr then
          vim.fn.setreg("+", pnr)
          vim.schedule(function()
            vim.notify("✅ PNR: " .. pnr .. " (copiado al clipboard)", vim.log.levels.INFO)
          end)
          break
        end
      end
    end,
  })
end, { desc = "Ejecutar script Python (terminal + PNR auto-copiado)" })
