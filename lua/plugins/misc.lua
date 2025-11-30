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

  -- Git 细粒度标记与操作
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function(_, opts)
      opts = opts or {}
      opts.signs = vim.tbl_deep_extend("force", {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "┅" },
        untracked = { text = "┆" },
      }, opts.signs or {})
      opts.signs_staged = vim.tbl_deep_extend("force", {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "┅" },
        untracked = { text = "┆" },
      }, opts.signs_staged or {})
      opts.signs_staged_enable = true
      opts.sign_priority = 8
      opts.current_line_blame = true
      opts.current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 400,
        ignore_whitespace = true,
      }
      opts.preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 1,
        col = 1,
      }

      local old_on_attach = opts.on_attach
      opts.on_attach = function(bufnr)
        if old_on_attach then
          old_on_attach(bufnr)
        end
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk 导航
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "下一个 Git 变更")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "上一个 Git 变更")

        -- Hunk 操作
        map("n", "<leader>gs", gs.stage_hunk, "暂存当前 Hunk")
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "暂存选中 Hunk")
        map("n", "<leader>gu", gs.undo_stage_hunk, "撤销暂存 Hunk")
        map("n", "<leader>gr", gs.reset_hunk, "重置当前 Hunk")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "重置选中 Hunk")
        map("n", "<leader>gS", gs.stage_buffer, "暂存当前文件")
        map("n", "<leader>gR", gs.reset_buffer, "重置当前文件")

        -- 查看与比较
        map("n", "<leader>gp", gs.preview_hunk, "预览当前 Hunk")
        map("n", "<leader>gi", gs.preview_hunk_inline, "内联预览 Hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "查看完整 Blame")
        map("n", "<leader>gd", gs.diffthis, "与索引对比")
        map("n", "<leader>gD", function()
          gs.diffthis("~")
        end, "与上一次提交对比")

        -- 切换与列表
        map("n", "<leader>gl", gs.toggle_current_line_blame, "切换行内 Blame")
        map("n", "<leader>gw", gs.toggle_word_diff, "切换字级 diff")
        map("n", "<leader>gq", gs.setqflist, "当前文件变更列表")
        map("n", "<leader>gQ", function()
          gs.setqflist("all")
        end, "工作区变更列表")

        map({ "o", "x" }, "ih", gs.select_hunk, "选择 Git Hunk")
      end

      return opts
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {
      show = true,
      set_highlights = false,
      -- 结合 hlslens 提供搜索位置指示
      handlers = { diagnostic = true, search = true },
    },
  },

  -- 搜索结果高亮增强，配合 scrollbar 展示匹配位置
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    opts = {
      calm_down = true,
      nearest_only = true,
      nearest_float_when = "never",
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = { char = "|", highlight = "NonText" },
      scope = { enabled = false },
      exclude = {
        filetypes = { "alpha", "dashboard", "lazy", "neo-tree", "mason" },
      },
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
        PERF = { icon = " ", color = "default" },
        NOTE = { icon = "󰎞 ", color = "hint" },
      },
      highlight = { keyword = "bg" },
    },
  },

  -- Fzf backend used by TodoFzfLua and other pickers
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
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
