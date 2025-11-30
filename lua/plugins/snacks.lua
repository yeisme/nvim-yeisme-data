-- Snacks Picker 修复：提供默认布局，避免 layout 为空导致报错
return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.picker = opts.picker or {}
      opts.picker.layout = opts.picker.layout or { preset = "default" }
      return opts
    end,
  },
}
