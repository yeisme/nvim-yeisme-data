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

  -- Mason：仅添加 LazyVim extras 未覆盖的工具
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server", -- shell 脚本
        "stylua", -- Lua 格式化
      })
      return opts
    end,
  },

  -- LSP 配置：仅覆盖需要自定义的服务器设置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "clangd", "--header-insertion=never", "--offset-encoding=utf-16" },
        },
      },
    },
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
        map("n", "<leader>gu", gs.stage_hunk, "切换暂存状态 Hunk")
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
        map("n", "<leader>gB", function()
          gs.blame_line({ full = true })
        end, "查看 Blame 详情")
        map("n", "<leader>gw", gs.toggle_word_diff, "切换字级 diff")
        map("n", "<leader>gq", gs.setqflist, "当前文件变更列表")
        map("n", "<leader>gQ", function()
          gs.setqflist({ all = true })
        end, "工作区变更列表")

        map({ "o", "x" }, "ih", gs.select_hunk, "选择 Git Hunk")
      end

      return opts
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gO", "<cmd>DiffviewOpen<cr>", desc = "Diffview: 与 HEAD 比较" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: 当前文件历史" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: 仓库历史" },
      { "<leader>gX", "<cmd>DiffviewClose<cr>", desc = "Diffview: 关闭" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
        default = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        win_config = { width = 36 },
      },
      hooks = {
        diff_buf_read = function(_)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    },
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
        filetypes = { "alpha", "dashboard", "lazy", "snacks_picker_list", "mason" },
      },
    },
  },

  -- 禁用 neo-tree，使用 snacks.explorer
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
        enable = true,
        disable = function(_, buf)
          local ok, line_count = pcall(vim.api.nvim_buf_line_count, buf)
          if ok and line_count > 5000 then
            return true
          end
          return false
        end,
      })
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

  -- Lua 开发体验：lazydev 提供 runtime/type 提示
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  -- DAP 调试体验
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    keys = function()
      local step_into_key = vim.g.neovide and "<F8>" or "<F11>"
      return {
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "DAP ����/����",
        },
        {
          "<F6>",
          function()
            require("dap").terminate()
          end,
          desc = "DAP ��������",
        },
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
          desc = "DAP Step Over",
        },
        {
          step_into_key,
          function()
            require("dap").step_into()
          end,
          desc = "DAP Step Into",
        },
        {
          "<F12>",
          function()
            require("dap").step_out()
          end,
          desc = "DAP Step Out",
        },
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "DAP �л��ϵ�",
        },
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "DAP �����ϵ�",
        },
        {
          "<leader>dl",
          function()
            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
          end,
          desc = "DAP ��־��",
        },
        {
          "<leader>dr",
          function()
            require("dap").restart()
          end,
          desc = "DAP ����",
        },
        {
          "<leader>de",
          function()
            require("dap").run_last()
          end,
          desc = "DAP �����ϴ�����",
        },
        {
          "<leader>du",
          function()
            require("dapui").toggle()
          end,
          desc = "DAP UI ���",
        },
        {
          "<leader>dk",
          function()
            require("dap").up()
          end,
          desc = "DAP ջ����",
        },
        {
          "<leader>dj",
          function()
            require("dap").down()
          end,
          desc = "DAP ջ����",
        },
        {
          "<leader>dx",
          function()
            local dap, dapui = require("dap"), require("dapui")
            dap.terminate()
            dapui.close()
          end,
          desc = "DAP ��ֹ���ر� UI",
        },
      }
    end,

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Mason 自动安装常用调试器
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "codelldb", "node2", "delve" },
        automatic_installation = true,
        handlers = {},
      })

      -- UI 布局与虚拟文本
      require("nvim-dap-virtual-text").setup({
        commented = true,
        highlight_changed_variables = true,
      })

      ---@diagnostic disable-next-line:missing-fields
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "left",
          },
          {
            elements = { "repl", "console" },
            size = 0.25,
            position = "bottom",
          },
        },
        floating = { border = "rounded", mappings = { close = { "q", "<Esc>" } } },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- 更清晰的断点符号
      local function sign(name, text, hl)
        vim.fn.sign_define(name, { text = text, texthl = hl or name, numhl = "" })
      end
      sign("DapBreakpoint", "", "DiagnosticError")
      sign("DapBreakpointCondition", "", "DiagnosticWarn")
      sign("DapStopped", "", "DiagnosticInfo")
      sign("DapLogPoint", "◆", "DiagnosticHint")
      sign("DapBreakpointRejected", "", "DiagnosticError")
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
    },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "会话：当前目录",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "会话：选择",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "会话：上次",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "会话：停止保存",
      },
    },
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

  -- 快速包围操作
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- 项目级搜索替换
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Spectre",
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Spectre 搜索/替换",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Spectre 当前词",
        mode = "n",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual()
        end,
        desc = "Spectre 选择文本",
        mode = "v",
      },
      {
        "<leader>sp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "Spectre 当前文件",
      },
    },
    opts = {
      open_cmd = "vnew", -- 垂直窗口便于对照
      live_update = true,
      highlight = {
        ui = "IncSearch",
        search = "IncSearch",
        replace = "DiffDelete",
      },
    },
  },

  -- 更智能的折叠体验（Treesitter + 缩进）
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "打开全部折叠",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "收起全部折叠",
      },
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts = opts or {}
      opts.mapping = opts.mapping or {}
      opts.mapping["<C-y>"] = cmp.mapping.confirm({ select = true })
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "emoji" })
      return opts
    end,
  },

  -- VSCode 风格：Ctrl + ` 打开/切换终端
  {
    "LazyVim/LazyVim",
    keys = function(_, keys)
      local function toggle_terminal_root()
        local ok, Snacks = pcall(require, "snacks")
        if ok and Snacks.terminal then
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        else
          -- 回退：在底部分屏开启内置终端
          vim.cmd("belowright split | resize 12 | terminal")
        end
      end

      table.insert(keys, {
        "<C-`>",
        toggle_terminal_root,
        mode = { "n", "t" },
        desc = "终端（Ctrl+`，根目录）",
      })
      return keys
    end,
  },
}
