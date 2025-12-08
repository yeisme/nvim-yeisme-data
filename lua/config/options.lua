-- 个人选项覆盖（LazyVim 已内置大部分合理默认值）
local opt = vim.opt

-- 覆盖 LazyVim 默认值
opt.scrolloff = 6      -- LazyVim 默认 4，个人偏好更大边距
opt.sidescrolloff = 8  -- LazyVim 默认 8
opt.timeoutlen = 400   -- LazyVim 默认 300，稍微宽松
opt.updatetime = 300   -- LazyVim 默认 200

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
