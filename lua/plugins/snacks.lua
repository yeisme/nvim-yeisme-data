-- Snacks 配置
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}

      -- Picker 通用布局
      opts.picker = opts.picker or {}
      opts.picker.layout = opts.picker.layout or { preset = "default" }

      -- Explorer 文件浏览器：使用 picker 的 sidebar 布局带预览
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = {
        layout = {
          preset = "sidebar",
          preview = "main", -- 预览在主编辑区显示
        },
        win = {
          list = {
            width = 32,
          },
        },
        auto_close = false,
      }

      -- Explorer 基础配置
      opts.explorer = opts.explorer or {}
      opts.explorer.replace_netrw = true

      return opts
    end,
  },
}
