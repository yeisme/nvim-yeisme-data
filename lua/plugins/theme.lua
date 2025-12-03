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
      colors = {
        onedark_vivid = {
          bg = "#0f111a",
          fg = "#c8d3f5",
          gray = "#6b7089",
          blue = "#7aa2f7",
          cyan = "#8bd5ca",
          purple = "#c099ff",
          red = "#f7768e",
          yellow = "#e0af68",
          green = "#9ece6a",
        },
      },
      highlights = {
        Normal = { bg = "#0f111a" },
        NormalFloat = { bg = "#111422" },
        FloatBorder = { fg = "#2c3040", bg = "#111422" },
        WinSeparator = { fg = "#242839" },
        VertSplit = { fg = "#242839" },
        CursorLine = { bg = "#191d2b" },
        ColorColumn = { bg = "#191d2b" },
        LineNr = { fg = "#454b62" },
        CursorLineNr = { fg = "#c8d3f5", bold = true },
        Visual = { bg = "#2a3350" },
        Search = { bg = "#2a3b4e", fg = "#c8d3f5", bold = true },
        IncSearch = { bg = "#3b425b", fg = "#c8d3f5", bold = true },
        Pmenu = { bg = "#121626" },
        PmenuSel = { bg = "#1c2236" },
        StatusLine = { bg = "#131828", fg = "#c8d3f5" },
        StatusLineNC = { bg = "#0f111a", fg = "#555c76" },
        TabLine = { bg = "#0f111a", fg = "#555c76" },
        TabLineSel = { bg = "#1c2236", fg = "#c8d3f5" },
        TelescopeSelection = { bg = "#1c2236" },
        TelescopePromptNormal = { bg = "#121626" },
        TelescopePromptBorder = { fg = "#1f2435", bg = "#121626" },
        TelescopeResultsNormal = { bg = "#10121d" },
        TelescopeResultsBorder = { fg = "#1f2435", bg = "#10121d" },
        TelescopePreviewNormal = { bg = "#10121d" },
        TelescopePreviewBorder = { fg = "#1f2435", bg = "#10121d" },
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
