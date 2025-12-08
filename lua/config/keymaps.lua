-- 个人快捷键（LazyVim 已内置：<leader>e 文件树、[d/]d 诊断、<leader>cf 格式化等）
local map = vim.keymap.set

-- 文件操作（LazyVim 无此快捷键）
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "保存文件" })
map("n", "<leader>fq", "<cmd>qa!<cr>", { desc = "强制退出" })

-- 终端（自定义根目录终端）
local function toggle_terminal_root()
  local ok, Snacks = pcall(require, "snacks")
  if ok and Snacks.terminal then
    Snacks.terminal(nil, { cwd = LazyVim.root() })
  else
    vim.cmd("belowright split | resize 12 | terminal")
  end
end
map("n", "<leader>tt", toggle_terminal_root, { desc = "终端（根目录）" })

-- 切换相对行号
map("n", "<leader>rn", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "切换相对行号" })

-- 窗口调整（Alt 键系列）
map("n", "<A-h>", "<C-w>h", { desc = "跳到左窗口" })
map("n", "<A-j>", "<C-w>j", { desc = "跳到下窗口" })
map("n", "<A-k>", "<C-w>k", { desc = "跳到上窗口" })
map("n", "<A-l>", "<C-w>l", { desc = "跳到右窗口" })
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "增加高度" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "减少高度" })
map("n", "<A-Left>", "<cmd>vertical resize -4<cr>", { desc = "减少宽度" })
map("n", "<A-Right>", "<cmd>vertical resize +4<cr>", { desc = "增加宽度" })

-- LSP 补充快捷键（LazyVim 已有 <leader>ca 代码操作、<leader>cr 重命名）
map("n", "<leader>sd", function()
  vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
end, { desc = "悬浮诊断" })
map("n", "<leader>uh", "<cmd>NoiceHistory<cr>", { desc = "通知历史" })

-- 系统剪贴板（Windows/GUI 习惯）
map({ "n", "v" }, "<C-c>", '"+y', { desc = "复制" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "粘贴" })
map({ "n", "v" }, "<C-x>", '"+d', { desc = "剪切" })

-- 插入模式快速退出
map("i", "jk", "<Esc>", { desc = "退出插入模式" })

-- 终端模式
map("t", "<C-v>", [[<C-\><C-n>"+pi]], { desc = "终端粘贴" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "终端退出" })
map("t", "jk", [[<C-\><C-n>]], { desc = "终端退出" })
