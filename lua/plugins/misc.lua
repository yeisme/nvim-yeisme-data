-- 其他小型增强：which-key、滚动条、缩进线、文件树、Treesitter、TODO、高级终端、补全源
return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.win = opts.win or {}
      opts.win.border = "rounded"
      -- 统一设置图标，确保新加的中文分组也有符号显示
      opts.icons = vim.tbl_deep_extend("force", opts.icons or {}, {
        breadcrumb = "»",
        separator = "➜",
        group = " ", -- 需 Nerd Font；JetBrainsMonoNL Nerd Font 已包含
      })
      opts.spec = vim.list_extend(opts.spec or {}, {
        { "<leader>f", group = "文件" },
        { "<leader>s", group = "搜索" },
        { "<leader>b", group = "缓冲区" },
        { "<leader>g", group = "Git/版本" },
        { "<leader>c", group = "代码" },
        { "<leader>t", group = "切换/工具" },
      })
      return opts
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show = true,
      set_highlights = false,
      -- 禁用 hlslens 搜索 handler，避免缺少模块的提示
      handlers = { diagnostic = true, search = false },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = { char = "│", highlight = "NonText" },
      scope = { enabled = false },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.width = 32
      opts.default_component_configs = opts.default_component_configs or {}
      opts.default_component_configs.indent = vim.tbl_deep_extend("force", opts.default_component_configs.indent or {}, {
        indent_size = 2,
        padding = 1,
      })
      opts.default_component_configs.git_status = vim.tbl_deep_extend("force", opts.default_component_configs.git_status or {}, {
        symbols = { added = "＋", modified = "∙", deleted = "－", renamed = "↺" },
      })
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, { enable = true })
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "vim",
        "vimdoc",
      })
      return opts
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error" },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning" },
        PERF = { icon = " ", color = "default" },
        NOTE = { icon = " ", color = "hint" },
      },
      highlight = { keyword = "bg" },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = { border = "rounded" },
      shade_terminals = false,
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = opts.mapping or {}
      opts.mapping["<C-y>"] = cmp.mapping.confirm({ select = true })
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
