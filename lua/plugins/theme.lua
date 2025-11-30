-- 主题与基础配色（One Dark Pro）
return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparency = false,
        cursorline = true,
        bold = true,
      },
      styles = {
        comments = "italic",
        keywords = "bold",
        functions = "italic",
      },
      plugins = {
        all = false,
        nvim_lsp = true,
        treesitter = true,
        telescope = true,
        gitsigns = true,
        nvim_cmp = true,
      },
    },
    config = function(_, opts)
      local onedarkpro = require("onedarkpro")
      onedarkpro.setup(opts)
      vim.cmd.colorscheme("onedark_vivid")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "onedark_vivid" },
  },
}
