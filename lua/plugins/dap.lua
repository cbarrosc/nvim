-- Debug Adapter Protocol: nvim-dap + nvim-dap-ui + virtual text
return {
  -- Core DAP client (activa la integración opcional de lang.java)
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured.",
    dependencies = {
      -- UI para debugging (ventanas de variables, stack, breakpoints)
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP UI Toggle" },
          { "<leader>de", function() require("dapui").eval() end, desc = "DAP Eval", mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          -- Abrir UI automáticamente al iniciar debug, cerrar al terminar
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      -- Muestra valores de variables inline en el código durante debug
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      -- Iniciar / continuar
      { "<leader>dc", function() require("dap").continue() end,          desc = "DAP Continue / Start" },
      -- Detener
      { "<leader>dq", function() require("dap").terminate() end,         desc = "DAP Terminate" },
      -- Step over (siguiente linea sin entrar a funciones)
      { "<leader>dn", function() require("dap").step_over() end,         desc = "DAP Step Over" },
      -- Step into (entrar a la función)
      { "<leader>di", function() require("dap").step_into() end,         desc = "DAP Step Into" },
      -- Step out (salir de la función actual)
      { "<leader>do", function() require("dap").step_out() end,          desc = "DAP Step Out" },
      -- Toggle breakpoint en la línea actual
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      -- Breakpoint condicional
      { "<leader>dB", function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, desc = "DAP Conditional Breakpoint" },
      -- Hover: ver valor de variable bajo el cursor
      { "<leader>dh", function() require("dap.ui.widgets").hover() end,  desc = "DAP Hover Variable" },
      -- REPL interactivo
      { "<leader>dr", function() require("dap").repl.open() end,         desc = "DAP Open REPL" },
      -- Listar breakpoints
      { "<leader>dl", function() require("dap").list_breakpoints() end,  desc = "DAP List Breakpoints" },
      -- Limpiar todos los breakpoints
      { "<leader>dD", function() require("dap").clear_breakpoints() end, desc = "DAP Clear Breakpoints" },
    },
  },
}
