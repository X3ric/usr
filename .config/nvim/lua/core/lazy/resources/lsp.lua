return {
  { -- provides improved lsp
    "glepnir/lspsaga.nvim",
    lazy = true,
    config = function ()
      require("lspsaga").setup({})
    end
  },
  { -- provides lsp configurations
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    keys = {
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
      { "<leader>lI", "<cmd>LspInstall<cr>", desc = "Installe lsp for current format" },
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", desc = "Next Diagnostic" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", desc = "Prev Diagnostic" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      { "<leader>W",
        function()
          vim.lsp.buf.format({
            filter = function(client)
              -- do not use default `lua_ls` to format
              local exclude_servers = { "lua_ls", "pyright", "pylsp" }
              return not vim.tbl_contains(exclude_servers, client.name)
            end,
          })
          vim.cmd([[w!]])
        end,
        desc = "Format and Save",
      },
      { "gf",
        function()
          vim.lsp.buf.format({
            filter = function(client)
              -- do not use default `lua_ls` to format
              local exclude_servers = { "lua_ls" }
              return not vim.tbl_contains(exclude_servers, client.name)
            end,
          })
          --vim.cmd([[w!]])
        end,
        desc = "Format text",
      },
    },
    config = function()
      -- special attach lsp
      require("plugins.resources.util").on_attach(function(client, buffer)
        require("plugins.configs.lsp.navic").attach(client, buffer)
        require("plugins.configs.lsp.keymaps").attach(client, buffer)
        require("plugins.configs.lsp.inlayhints").attach(client, buffer)
        require("plugins.configs.lsp.gitsigns").attach(client, buffer)
        require("plugins.configs.lsp.python").attach(client, buffer)
      end)
      -- diagnostics
      for name, icon in pairs(require("custom.icons").diagnostics) do
        local function firstUpper(s)
          return s:sub(1, 1):upper() .. s:sub(2)
        end
        name = "DiagnosticSign" .. firstUpper(name)
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(require("plugins.configs.lsp.diagnostics")["on"])

      local servers = require("plugins.configs.lsp.servers")
      local ext_capabilites = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require("plugins.resources.util").capabilities(ext_capabilites)

      local function setup(server)
        if servers[server] and servers[server].disabled then
          return
        end
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      local available = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          if not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end
      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
    end,
  },
  { -- mason lsp provider
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  { -- dap debugger
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>ldb", "<cmd>DapToggleBreakpoint<cr>", desc = "Add breakpoint at line" },
      { "<leader>ldr", "<cmd>DapContinue<cr>", desc = "Start or continue the debugger" },
    }
  },
  { -- mason dap module
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },
  { -- formatters,lspall in one provider
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions
      null_ls.setup({
        debug = false,
        -- You can then register sources by passing a sources list into your setup function:
        -- using `with()`, which modifies a subset of the source's default options
        sources = {
          -- formatting.prettier,
          formatting.eslint_d,
          diagnostics.eslint_d,
          code_actions.eslint_d,
          formatting.stylua,
          formatting.markdownlint,
          formatting.beautysh.with({ extra_args = { "--indent-size", "2" } }),
          formatting.black.with({ extra_args = { "--line-length", "120" } }),
          diagnostics.flake8.with({
            extra_args = { "--ignore=E501,E402,E722,F821,W503,W292,E203" },
            filetypes = { "python" },
          }),
        },
      })
    end,
  },
  { -- mason null-ls module
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "eslint_d",
        "prettier",
        "stylua",
        "google_java_format",
        "black",
        "flake8",
        "css-lsp",
        "markdownlint",
        "beautysh",
        "clangd",
        "clang-format",
        "codelldb",
      },
      automatic_setup = true,
    },
  },
  { -- built-in Language Server Protocol
    "mfussenegger/nvim-jdtls",
  },
}
