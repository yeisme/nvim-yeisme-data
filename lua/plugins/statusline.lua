-- 底部状态栏：矩形规则样式（取消圆角）
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local function get_color(name, fallback)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        if ok and hl and hl.fg then
          return string.format("#%06x", hl.fg)
        end
        return fallback
      end

      local function lsp_names()
        local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
        local names = {}
        for _, client in ipairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(names, client.name)
          end
        end
        if #names == 0 then
          return ""
        end
        return "LSP: " .. table.concat(names, ",")
      end

      local function formatters()
        local ok, conform = pcall(require, "conform")
        if not ok then
          return ""
        end
        local list = conform.list_formatters(0) or {}
        if #list == 0 then
          return ""
        end
        local names = {}
        for _, item in ipairs(list) do
          table.insert(names, item.name)
        end
        return "FMT: " .. table.concat(names, ",")
      end

      local block = function(component, color)
        component.padding = { left = 2, right = 2 }
        component.color = color
        return component
      end

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = "onedark",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      })

      opts.sections = {
        lualine_a = {
          block({ "mode", fmt = function(str) return str:sub(1, 1) end }, {}),
        },
        lualine_b = {
          block({ "branch" }, {}),
          block({ "diff" }, {}),
        },
        lualine_c = {
          block({
            "filename",
            path = 1,
            symbols = { modified = " ⌘", readonly = " " },
          }, {}),
          block({ lsp_names, cond = function() return lsp_names() ~= "" end }, { fg = get_color("DiagnosticInfo", "#8aadf4") }),
          block({ formatters, cond = function() return formatters() ~= "" end }, { fg = get_color("DiagnosticHint", "#7dc4e4") }),
        },
        lualine_x = {
          block({
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = "💡 " },
          }, {}),
          block({ "filetype", icon_only = false }, {}),
        },
        lualine_y = {
          block({ function() return (vim.bo.fileencoding or "utf-8") .. "/" .. (vim.bo.fileformat or "lf") end }, {}),
          block({ "progress" }, {}),
        },
        lualine_z = {
          block({ "location" }, {}),
        },
      }

      opts.inactive_sections = {
        lualine_a = {
          block({ "filename", path = 1 }, {}),
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
