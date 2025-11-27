-- Telescope 搜索：暗色圆角与顶部输入框
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-live-grep-args.nvim" },
    opts = function(_, opts)
      local lga = require("telescope").load_extension
      pcall(lga, "live_grep_args")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = "🔍 ",
        selection_caret = "› ",
        layout_config = { width = 0.92, height = 0.88, prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "smart" },
        borderchars = { "╭", "╮", "╯", "╰", "│", "─", "│", "─" },
      })
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = { previewer = false, prompt_title = "文件搜索" }
      opts.extensions = opts.extensions or {}
      opts.extensions.live_grep_args = {
        auto_quoting = true,
        mappings = { i = { ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt() } },
      }
      return opts
    end,
  },
}
