-- 这里放置个人常用的 Neovim 选项，配合 LazyVim 默认值进一步优化体验
local opt = vim.opt

-- 视觉与互动
opt.number = true -- 显示行号
opt.relativenumber = true -- 使用相对行号方便跳转
opt.signcolumn = "yes" -- 始终显示标记栏避免晃动
opt.cursorline = true -- 突出当前行
opt.termguicolors = true -- 启用真彩
opt.laststatus = 3 -- 单一全局状态栏

-- 编辑行为
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true -- 以空格代替 Tab
opt.smartindent = true -- 自动缩排
opt.wrap = false -- 关闭自动换行
opt.scrolloff = 6 -- 预留滚动边距
opt.sidescrolloff = 8

-- 搜索体验
opt.ignorecase = true -- 默认忽略大小写
opt.smartcase = true -- 若包含大写则区分大小写
opt.inccommand = "split" -- 查找替换预览

-- 系统整合
opt.clipboard = "unnamedplus" -- 与系统剪贴板互通
opt.mouse = "a" -- 开启鼠标支持

-- 性能细节
opt.updatetime = 300 -- 减少延迟
opt.timeoutlen = 400 -- 快捷键超时更灵敏

-- 默认终端：按平台和可用性选择
local function pick_shell()
  if vim.fn.has("win32") == 1 then
    if vim.fn.executable("pwsh") == 1 then
      return "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      return "powershell"
    end
    return "cmd"
  else
    if vim.fn.executable("zsh") == 1 then
      return "zsh"
    elseif vim.fn.executable("bash") == 1 then
      return "bash"
    end
  end
end

local preferred_shell = pick_shell()
if preferred_shell then
  opt.shell = preferred_shell
end
