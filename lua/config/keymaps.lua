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

-- 窗口跳转（Alt + h/j/k/l）
map("n", "<A-h>", "<C-w>h", { desc = "跳到左窗口" })
map("n", "<A-j>", "<C-w>j", { desc = "跳到下窗口" })
map("n", "<A-k>", "<C-w>k", { desc = "跳到上窗口" })
map("n", "<A-l>", "<C-w>l", { desc = "跳到右窗口" })

-- Telescope 常用入口
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "搜索文件" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "全局搜索" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "切换缓冲区" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "帮助文档" })

-- LSP/診斷快捷方式
map("n", "<leader>sd", function()
  vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
end, { desc = "查看當前診斷" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
