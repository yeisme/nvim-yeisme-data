-- 底部状态栏：矩形规则样式（取消圆角）
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local palette = require("catppuccin.palettes").get_palette("mocha")
      local block = function(component, color)
        component.padding = { left = 2, right = 2 }
        component.color = color
        return component
      end

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      })

      opts.sections = {
        lualine_a = {
          block({ "mode", fmt = function(str) return str:sub(1, 1) end }, { bg = palette.blue, fg = palette.base }),
        },
        lualine_b = {
          block({ "branch" }, { bg = palette.surface1, fg = palette.text }),
          block({ "diff" }, { bg = palette.surface1, fg = palette.text }),
        },
        lualine_c = {
          block({
            "filename",
            path = 1,
            symbols = { modified = " ⌘", readonly = " " },
          }, { bg = palette.surface0, fg = palette.text }),
        },
        lualine_x = {
          block({
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = "💡 " },
          }, { bg = palette.surface0, fg = palette.text }),
          block({ "filetype", icon_only = false }, { bg = palette.surface0, fg = palette.text }),
        },
        lualine_y = {
          block({ "progress" }, { bg = palette.surface1, fg = palette.text }),
        },
        lualine_z = {
          block({ "location" }, { bg = palette.blue, fg = palette.base }),
        },
      }

      opts.inactive_sections = {
        lualine_a = {
          block({ "filename", path = 1 }, { bg = palette.surface0, fg = palette.text }),
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }

      return opts
    end,
  },
}
