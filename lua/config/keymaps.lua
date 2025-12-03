-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- 个人习惯快捷键（中文描述方便记忆）
local map = vim.keymap.set

-- 文件与会话
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "保存文件" })
map("n", "<leader>fq", "<cmd>qa!<cr>", { desc = "直接退出" })
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "切换文件树" })
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "浮动终端" })
map("n", "<leader>rn", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "切换相对行号" })

-- 窗口跳转与尺寸调整
map("n", "<A-h>", "<C-w>h", { desc = "跳到左窗口" })
map("n", "<A-j>", "<C-w>j", { desc = "跳到下窗口" })
map("n", "<A-k>", "<C-w>k", { desc = "跳到上窗口" })
map("n", "<A-l>", "<C-w>l", { desc = "跳到右窗口" })
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "增加高度" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "减少高度" })
map("n", "<A-Left>", "<cmd>vertical resize -4<cr>", { desc = "减少宽度" })
map("n", "<A-Right>", "<cmd>vertical resize +4<cr>", { desc = "增加宽度" })
map("n", "<C-A-Left>", "<cmd>vertical resize -4<cr>", { desc = "减少宽度 (Ctrl+Alt)" })
map("n", "<C-A-Right>", "<cmd>vertical resize +4<cr>", { desc = "增加宽度 (Ctrl+Alt)" })
map("n", "<leader>w=", "<C-w>=", { desc = "平分窗口大小" })

-- Telescope 常用入口
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "搜索文件" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "全局搜索" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "切换缓冲区" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "帮助文档" })

-- 快速命令/搜索体验（终端无法捕获单独双击 Ctrl/Shift，改用顺手组合）
map("n", "<leader>:", function()
  vim.api.nvim_feedkeys(":", "n", false)
end, { desc = "进入命令行" })
map("n", "<C-p>", function()
  vim.api.nvim_feedkeys(":", "n", false)
end, { desc = "进入命令行（保留 Ctrl+p）" })

-- LSP/诊断快捷方式
map("n", "<leader>sd", function()
  vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
end, { desc = "查看当前诊断" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
map("n", "<leader>cf", function()
  local ok = pcall(vim.lsp.buf.format, { async = true })
  if not ok and vim.lsp.buf.formatting then
    vim.lsp.buf.formatting()
  end
end, { desc = "格式化当前缓冲区" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "代码操作" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "重命名符号" })
map("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { desc = "诊断列表" })
map("n", "<leader>uh", "<cmd>NoiceHistory<cr>", { desc = "查看通知历史" })

-- 系统剪贴板友好：视觉模式 Ctrl+C 复制，Ctrl+V 粘贴
map({ "n", "v" }, "<C-c>", '"+y', { desc = "复制到系统剪贴板" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "从系统剪贴板粘贴" })
map({ "n", "v" }, "<C-S-v>", '"+p', { desc = "从系统剪贴板粘贴" })
map({ "n", "v" }, "<C-x>", '"+d', { desc = "剪切到系统剪贴板" })

-- 插入模式快速返回 Normal
map("i", "jk", "<Esc>", { desc = "插入模式退出" })
map("i", "kj", "<Esc>", { desc = "插入模式退出" })

-- 终端模式粘贴（退到 Normal 再粘贴）
map("t", "<C-v>", [[<C-\><C-n>"+pi]], { desc = "终端粘贴系统剪贴板" })
map("t", "<C-S-v>", [[<C-\><C-n>"+pi]], { desc = "终端粘贴系统剪贴板" })

-- 终端模式快速返回 Normal
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "终端退出到 Normal" })
map("t", "jk", [[<C-\><C-n>]], { desc = "终端退出到 Normal" })
