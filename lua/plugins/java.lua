-- Configuración de nvim-jdtls para proyectos Java con Gradle composite builds.
-- Extiende el extra lang.java de LazyVim con settings específicos para este proyecto:
--   - Lombok + MapStruct (annotation processors)
--   - Spring Boot / Spring WebFlux
--   - Configuraciones de launch para Gradle bootRun con debug remoto
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Extender settings del jdtls con soporte para annotation processors y Spring
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          -- Annotation processors: Lombok y MapStruct
          -- jdtls los detecta via Gradle automáticamente, pero esto los refuerza
          configuration = {
            updateBuildConfiguration = "automatic",
          },
          -- Compilacion incremental más agresiva
          autobuild = { enabled = true },
          -- Completions más detallados
          completion = {
            favoriteStaticMembers = {
              "org.assertj.core.api.Assertions.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            importOrder = { "java", "javax", "org", "com" },
          },
          -- Formato de código
          format = {
            enabled = true,
          },
          -- Inlay hints (ya configurados en el extra, pero los reforzamos)
          inlayHints = {
            parameterNames = { enabled = "all" },
          },
          -- Reducir falsos positivos de diagnósticos en proyectos grandes
          maxConcurrentBuilds = 1,
          -- Spring Boot: habilitar soporte de Spring Data y Beans
          springBoot = {
            enabled = true,
          },
          -- Gradle: respetar el wrapper del proyecto
          gradle = {
            enabled = true,
          },
        },
      })

      -- Agregar launch configurations para Spring Boot vía Gradle
      -- Se añaden a las configs que el extra ya crea (remote attach en :5005)
      --
      -- FLUJO DE DEBUG:
      --   1. En terminal: ./gradlew bootRun --debug-jvm  (arranca en :5005, espera debugger)
      --   2. En nvim:     <leader>dc → seleccionar "Attach Spring Boot (:5005)"
      opts.jdtls = function(config)
        -- dap.configurations.java se llena dinámicamente por el extra de LazyVim
        -- y por jdtls.dap.setup_dap_main_class_configs. Aquí sólo nos aseguramos
        -- de que la configuración de attach esté disponible como fallback.
        local ok, dap = pcall(require, "dap")
        if ok then
          local existing = dap.configurations.java or {}
          -- Verificar que la config de attach no esté duplicada
          local has_attach = false
          for _, c in ipairs(existing) do
            if c.request == "attach" then has_attach = true; break end
          end
          if not has_attach then
            table.insert(existing, {
              type    = "java",
              request = "attach",
              name    = "Attach Spring Boot (:5005)",
              hostName = "127.0.0.1",
              port    = 5005,
            })
          end
          dap.configurations.java = existing
        end
        return config
      end

      return opts
    end,
  },

  -- Asegurar que Mason instale las herramientas de debug/test Java
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "java-debug-adapter",
        "java-test",
      },
    },
  },
}
