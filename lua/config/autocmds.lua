-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- 个人化自动命令：保持简洁，全部中文注释
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 拷贝后高亮，方便确认 yank 范围
autocmd("TextYankPost", {
  group = augroup("local_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- 打开文件自动跳回上次光标位置
autocmd("BufReadPost", {
  group = augroup("local_restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 终端模式自动进入插入态
autocmd("TermOpen", {
  group = augroup("local_terminal_start_insert", { clear = true }),
  command = "startinsert",
})

-- 大文件保护：超过 1MB 或 10000 行时，关闭重型功能
autocmd("BufReadPre", {
  group = augroup("local_bigfile_optimize", { clear = true }),
  callback = function(args)
    local stat = vim.loop.fs_stat(args.file)
    if not stat then
      return
    end
    local is_big = (stat.size and stat.size > 1024 * 1024) or (vim.api.nvim_buf_line_count(args.buf) > 10000)
    if not is_big then
      return
    end
    vim.b[args.buf].large_file = true
    vim.cmd("syntax off")
    pcall(vim.treesitter.stop, args.buf)
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.swapfile = false
  end,
})
