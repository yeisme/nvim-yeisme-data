-- 个人自动命令（LazyVim 已内置：yank 高亮、光标恢复、终端自动插入）
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
