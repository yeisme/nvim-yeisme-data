-- 顶部缓冲区标签：规则矩形样式，空时隐藏
return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = function(_, opts)
      local palette = require("catppuccin.palettes").get_palette("mocha")
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        mode = "buffers",
        separator_style = "thin", -- 规则分隔，无圆角
        diagnostics = false, -- 关闭 LSP 诊断标记，减少频繁刷新带来的开销
        show_buffer_close_icons = false, -- 不显示标签关闭按钮
        show_close_icon = false, -- 关闭全局关闭按钮
        close_command = nil,
        hover = nil,
        -- 不显示 Neo-tree 左侧标题
        offsets = { { filetype = "neo-tree", text = nil, highlight = "Directory", separator = true } },
        indicator = { style = "underline" },
        always_show_bufferline = false, -- 无缓冲区时隐藏顶栏
      })

      -- 手动配色，避免背景纯黑
      opts.highlights = {
        fill = { bg = palette.mantle },
        background = { bg = palette.mantle, fg = palette.overlay0 },
        buffer_selected = { bg = palette.base, fg = palette.text, bold = true },
        buffer_visible = { bg = palette.mantle, fg = palette.text },
        separator = { fg = palette.mantle, bg = palette.mantle },
        separator_selected = { fg = palette.mantle, bg = palette.base },
        separator_visible = { fg = palette.mantle, bg = palette.mantle },
        indicator_selected = { fg = palette.blue, bg = palette.base },
      }

      return opts
    end,
  },
}
