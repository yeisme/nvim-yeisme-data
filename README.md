# 我的 LazyVim 配置

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人定制，包含 Neovide 美化、Barbar 标签栏、圆角 Lualine、Telescope 定制、Noice/Notify 圆角弹窗，以及常用的 LSP/DAP/开发工具预设。

## 依赖

- Neovim 0.10+（推荐最新版）
- Git
- [JetBrainsMonoNL Nerd Font](https://www.nerdfonts.com/font-downloads)（Neovide 字体依赖）
- 建议安装：`ripgrep`、`fd`（提升 Telescope 速度），按需准备 Node/Python/Go/Rust 等语言工具链

## 安装

1. 备份旧配置
   - Windows: `C:\Users\<你>\AppData\Local\nvim`
   - Linux/macOS: `~/.config/nvim`
2. 将仓库放到配置目录（覆盖旧文件）：

   ```powershell
   # Windows PowerShell
   cd $env:LOCALAPPDATA
   git clone <repo-url> nvim
   ```

   ```bash
   # macOS / Linux
   cd ~/.config
   git clone <repo-url> nvim
   ```

3. 首次启动 `nvim` 自动拉取 Lazy.nvim 和插件；进入后可执行 `:Lazy sync` 确保安装完成。

## Neovide 说明

- 安装 Neovide 后直接运行即可读取本配置。
- 若光标特效影响流畅度，可在 `lua/config/neovide.lua` 将 `neovide_cursor_vfx_mode` 设为 `nil`，或把 `neovide_cursor_animation_length` 调低甚至设为 `0`。
- 字体/行距等可在同文件修改 `o.guifont`、`o.linespace`。

## 更新插件

- `:Lazy sync` 或 `:Lazy update`
- 语言工具和 LSP 在 `:Mason` 里按需安装（已预置常见语言的 ensure_installed 列表）。
