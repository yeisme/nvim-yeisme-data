-- 顶部标签栏：使用 barbar.nvim 提供更美观的缓冲区标签
local function hl_color(name, attr, default)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and hl[attr] then
    return string.format("#%06x", hl[attr])
  end
  return default
end

return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = function()
      local normal_bg = hl_color("Normal", "bg", "#1f2430")
      local normal_fg = hl_color("Normal", "fg", "#e5e9f0")
      local line_bg = hl_color("CursorLine", "bg", "#282c34")
      local accent = hl_color("String", "fg", "#9ece6a")
      local warning = hl_color("WarningMsg", "fg", "#e0af68")
      local muted = hl_color("Comment", "fg", "#6c7086")

      return {
        animation = false,
        auto_hide = false,
        maximum_length = 30,
        minimum_length = 12,
        maximum_padding = 2,
        tabpages = true,
        insert_at_end = true,
        sidebar_filetypes = {
          ["neo-tree"] = { text = "文件树", event = "BufWinLeave" },
          Outline = { event = "BufWinLeave" },
        },
        icons = {
          buffer_index = true,
          buffer_number = false,
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
            [vim.diagnostic.severity.WARN] = { enabled = true, icon = " " },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = false },
          },
          button = "",
          modified = { button = "" },
          pinned = { button = "󰐃", filename = true },
          separator = { left = "▎", right = "" },
          inactive = { separator = { left = "▏" } },
        },
        letters = "asdfjklghnmpwertyuiovbczxASDFJKLGHNMPWERTYUIOVBCZX",
        highlight_inactive_file_icons = true,
        highlight_visible_file_icons = true,
        focus_on_close = "left",
        hide = { extensions = false, inactive = false, alternate = false },
        no_name_title = "未命名",
        highlights = {
          background = { fg = muted, bg = normal_bg },
          buffer_selected = { fg = normal_fg, bg = line_bg, bold = true },
          buffer_visible = { fg = normal_fg, bg = normal_bg },
          diagnostic = { fg = warning },
          diagnostic_visible = { fg = warning },
          modified = { fg = accent, bg = normal_bg },
          modified_selected = { fg = accent, bg = line_bg, bold = true },
          separator = { fg = normal_bg, bg = normal_bg },
          separator_selected = { fg = line_bg, bg = line_bg },
          pinned = { fg = accent },
          pick = { fg = "#ff9e64", bg = line_bg, bold = true },
          pick_visible = { fg = "#ff9e64", bg = normal_bg, bold = true },
        },
      }
    end,
    keys = {
      -- move focus
      { "<A-,>", "<Cmd>BufferPrevious<CR>", desc = "Barbar: 前一个标签" },
      { "<A-.>", "<Cmd>BufferNext<CR>", desc = "Barbar: 后一个标签" },
      -- move order
      { "<A-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Barbar: 标签左移" },
      { "<A->>", "<Cmd>BufferMoveNext<CR>", desc = "Barbar: 标签右移" },
      -- goto positions
      { "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "Barbar: 跳到标签1" },
      { "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "Barbar: 跳到标签2" },
      { "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "Barbar: 跳到标签3" },
      { "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "Barbar: 跳到标签4" },
      { "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "Barbar: 跳到标签5" },
      { "<A-6>", "<Cmd>BufferGoto 6<CR>", desc = "Barbar: 跳到标签6" },
      { "<A-7>", "<Cmd>BufferGoto 7<CR>", desc = "Barbar: 跳到标签7" },
      { "<A-8>", "<Cmd>BufferGoto 8<CR>", desc = "Barbar: 跳到标签8" },
      { "<A-9>", "<Cmd>BufferGoto 9<CR>", desc = "Barbar: 跳到标签9" },
      { "<A-0>", "<Cmd>BufferLast<CR>", desc = "Barbar: 跳到最后一个标签" },
      -- pin & close
      { "<A-p>", "<Cmd>BufferPin<CR>", desc = "Barbar: Pin 标签" },
      { "<A-c>", "<Cmd>BufferClose<CR>", desc = "Barbar: 关闭标签" },
      { "<A-S-c>", "<Cmd>BufferRestore<CR>", desc = "Barbar: 恢复关闭标签" },
      -- pick mode
      { "<leader>bs", "<Cmd>BufferPick<CR>", desc = "Barbar: 选择标签" },
      { "<leader>bx", "<Cmd>BufferPickDelete<CR>", desc = "Barbar: 选择并关闭" },
      -- ordering
      { "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "Barbar: 根据序号排序" },
      { "<leader>bn", "<Cmd>BufferOrderByName<CR>", desc = "Barbar: 根据名称排序" },
      { "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", desc = "Barbar: 根据目录排序" },
      { "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", desc = "Barbar: 根据语言排序" },
      { "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "Barbar: 根据窗口排序" },
      -- closing groups
      { "<leader>bc", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "Barbar: 关闭其他" },
      { "<leader>bp", "<Cmd>BufferCloseAllButPinned<CR>", desc = "Barbar: 仅保留固定" },
      { "<leader>bh", "<Cmd>BufferCloseBuffersLeft<CR>", desc = "Barbar: 关闭左侧" },
      { "<leader>bj>", "<Cmd>BufferCloseBuffersRight<CR>", desc = "Barbar: 关闭右侧" },
    },
  },
}
