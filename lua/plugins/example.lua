-- 个人化插件与界面优化，全部使用中文注释方便快速理解
-- 说明：LazyVim 会自动读取此目录下的所有 spec，此处聚焦提升体验与中文提示
return {
  -- 主题配色：柔和护眼
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- 告知 LazyVim 使用上方主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- 命令行/通知美化，提示更清晰
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "rcarriga/nvim-notify", "nvim-telescope/telescope.nvim", "MunifTanjim/nui.nvim" },
    opts = {
      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      routes = {
        -- 让无关紧要的讯息保持安静
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "wrapped-compact",
      stages = "fade",
      timeout = 3000,
      top_down = false,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- which-key 中文化分组，帮助记忆快捷键
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.win = opts.win or {}
      opts.win.border = "rounded"
      -- 官方已弃用 defaults，改用 spec 声明分组
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

  -- Telescope 搜索体验升级：中文描述与预览
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-live-grep-args.nvim" },
    opts = function(_, opts)
      local lga = require("telescope").load_extension
      pcall(lga, "live_grep_args")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = "  ",
        selection_caret = " ",
        layout_config = { width = 0.95, height = 0.90, prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "smart" },
      })
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = { previewer = false, prompt_title = "文件搜索" }
      opts.extensions = opts.extensions or {}
      opts.extensions.live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
          },
        },
      }
      return opts
    end,
  },

  -- 状态栏精简且展示 LSP 状态
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "tokyonight"
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = {
        { "mode", fmt = function(str) return str:sub(1, 1) end },
        { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
      }
      opts.sections.lualine_x = {
        { "branch" },
        { "diff" },
        { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
      }
      return opts
    end,
  },

  -- Neo-tree 调整视觉与常用键位提示
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
        symbols = { added = "", modified = "", deleted = "", renamed = "" },
      })
      return opts
    end,
  },

  -- Treesitter 确保常用语言解析
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

  -- TODO 标记彩色高亮
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

  -- 终端快捷呼出
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

  -- 补全加入 emoji 与优化确认键
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
