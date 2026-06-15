-- obsidian.nvim: editar vault de Obsidian desde Neovim
-- Vault: ~/Documents/Mind
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  -- Solo carga cuando abres un .md dentro del vault
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Documents/Mind/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Documents/Mind/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
  },
  opts = {
    workspaces = {
      {
        name = "Mind",
        path = "~/Documents/Mind",
      },
    },

    -- Completions: integrar con blink.cmp (ya instalado)
    completion = {
      nvim_cmp = false,
      min_chars = 2,
    },

    -- Navegar con 'gf' en [[wikilinks]] y URLs
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- Nuevo nombre de nota: usar titulo como nombre de archivo
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- Sin titulo: timestamp
        suffix = tostring(os.time())
      end
      return suffix
    end,

    -- Formato del frontmatter al crear notas nuevas
    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    -- Daily notes
    daily_notes = {
      folder = "Daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
    },

    -- UI desactivado: render-markdown.nvim maneja el renderizado
    ui = {
      enable = false,
    },

    -- Attachments (imagenes pegadas)
    attachments = {
      img_folder = "Assets",
    },

    picker = {
      name = "fzf-lua",
    },

    -- Keymaps (solo activos dentro de archivos .md del vault)
    mappings = {
      -- gf: seguir link bajo el cursor
      ["gf"] = {
        action = function() return require("obsidian").util.gf_passthrough() end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- <CR>: toggle checkbox
      ["<CR>"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true },
      },
      -- <leader>ch: toggle checkbox (alternativo)
      ["<leader>ch"] = {
        action = function() return require("obsidian").util.toggle_checkbox() end,
        opts = { buffer = true, desc = "Obsidian: Toggle checkbox" },
      },
    },
  },

  -- Keymaps globales (disponibles siempre, no solo en .md)
  keys = {
    { "<leader>of", "<cmd>ObsidianQuickSwitch<CR>",   desc = "Obsidian: Buscar nota" },
    { "<leader>os", "<cmd>ObsidianSearch<CR>",         desc = "Obsidian: Buscar contenido" },
    { "<leader>on", "<cmd>ObsidianNew<CR>",            desc = "Obsidian: Nueva nota" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<CR>",      desc = "Obsidian: Backlinks" },
    { "<leader>ot", "<cmd>ObsidianTags<CR>",           desc = "Obsidian: Tags" },
    { "<leader>od", "<cmd>ObsidianDailies<CR>",        desc = "Obsidian: Daily notes" },
    { "<leader>ol", "<cmd>ObsidianLink<CR>",           desc = "Obsidian: Insertar link", mode = { "n", "v" } },
    { "<leader>oL", "<cmd>ObsidianLinks<CR>",          desc = "Obsidian: Ver links" },
    { "<leader>oo", "<cmd>ObsidianOpen<CR>",           desc = "Obsidian: Abrir en app" },
    { "<leader>or", "<cmd>ObsidianRename<CR>",         desc = "Obsidian: Renombrar nota" },
    { "<leader>oT", "<cmd>ObsidianTemplate<CR>",       desc = "Obsidian: Insertar template" },
  },
}
