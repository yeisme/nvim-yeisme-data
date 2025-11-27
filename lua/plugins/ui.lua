-- 通知、命令行、输入选择等 UI 美化
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "rcarriga/nvim-notify", "nvim-telescope/telescope.nvim", "MunifTanjim/nui.nvim" },
    opts = {
      presets = { command_palette = true, long_message_to_split = true, lsp_doc_border = true },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      views = {
        mini = { border = { style = "rounded" } },
        cmdline_popup = {
          border = { style = "rounded" },
          position = { row = "35%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
      },
      routes = { { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } } },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = "wrapped-compact",
      stages = "fade",
      timeout = 2500,
      top_down = false,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { border = "rounded" },
      select = { backend = { "telescope", "builtin" } },
    },
  },
}
