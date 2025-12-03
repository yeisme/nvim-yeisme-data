-- Neovide-only UI tuning
if not vim.g.neovide then
  return
end

local g = vim.g
local o = vim.opt

-- 英文字体 + CJK 字体分开设置，确保中英文都渲染得体
o.guifont = "JetBrainsMonoNL Nerd Font:h13"
o.linespace = 2

local function with_alpha(hex, alpha)
  local channel = math.floor(255 * alpha)
  return hex .. string.format("%02x", channel)
end

local function normal_bg()
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false })
  if ok and hl and hl.bg then
    return string.format("#%06x", hl.bg)
  end
  return "#1e1e2e"
end

local function sync_background(alpha)
  local opacity = alpha or g.neovide_opacity or 0.92
  g.neovide_background_color = with_alpha(normal_bg(), opacity)
end

g.neovide_opacity = 0.92
sync_background()
g.neovide_window_blurred = true
g.neovide_floating_blur_amount_x = 6.0
g.neovide_floating_blur_amount_y = 6.0
g.neovide_floating_corner_radius = 6.0
g.neovide_floating_shadow = true
g.neovide_floating_z_height = 10.0
g.neovide_light_angle = 55
g.neovide_light_radius = 8
g.neovide_title_text = "Neovide"

g.neovide_hide_mouse_when_typing = true
g.neovide_remember_window_size = true
g.neovide_confirm_quit = true
g.neovide_padding_top = 4
g.neovide_padding_bottom = 4
g.neovide_padding_left = 6
g.neovide_padding_right = 6

g.neovide_refresh_rate = 120
g.neovide_scroll_animation_length = 0.05
g.neovide_cursor_animation_length = 0.02 -- keep cursor snap fast to reduce drag
g.neovide_cursor_trail_size = 0.25
g.neovide_cursor_antialiasing = true
g.neovide_cursor_vfx_mode = "railgun"
g.neovide_cursor_vfx_particle_lifetime = 0.6
g.neovide_cursor_vfx_particle_density = 10.0
g.neovide_cursor_smooth_blink = true
g.neovide_refresh_rate_idle = 90

g.neovide_scale_factor = g.neovide_scale_factor or 1.0
local function change_scale(delta)
  g.neovide_scale_factor = math.min(2.0, math.max(0.5, g.neovide_scale_factor + delta))
end

vim.keymap.set({ "n", "v", "i", "c" }, "<C-=>", function()
  change_scale(0.05)
end, { silent = true, desc = "Neovide: zoom in" })

vim.keymap.set({ "n", "v", "i", "c" }, "<C-->", function()
  change_scale(-0.05)
end, { silent = true, desc = "Neovide: zoom out" })

vim.keymap.set({ "n", "v", "i", "c" }, "<C-0>", function()
  g.neovide_scale_factor = 1.0
end, { silent = true, desc = "Neovide: reset zoom" })

vim.keymap.set("n", "<F11>", function()
  g.neovide_fullscreen = not g.neovide_fullscreen
end, { silent = true, desc = "Neovide: toggle fullscreen" })

vim.keymap.set("n", "<leader>ub", function()
  g.neovide_window_blurred = not g.neovide_window_blurred
end, { silent = true, desc = "Neovide: toggle window blur" })

local function change_opacity(delta)
  local next_opacity = math.min(1.0, math.max(0.6, (g.neovide_opacity or 0.92) + delta))
  g.neovide_opacity = next_opacity
  sync_background(next_opacity)
end

vim.keymap.set("n", "<leader>u+", function()
  change_opacity(0.03)
end, { silent = true, desc = "Neovide: increase opacity" })

vim.keymap.set("n", "<leader>u-", function()
  change_opacity(-0.03)
end, { silent = true, desc = "Neovide: decrease opacity" })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("local_neovide_background", { clear = true }),
  callback = function()
    sync_background()
  end,
})
