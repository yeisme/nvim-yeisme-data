-- Telescope 搜索：暗色圆角与顶部输入框
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-live-grep-args.nvim" },
    opts = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local lga_actions = require("telescope-live-grep-args.actions")
      pcall(telescope.load_extension, "live_grep_args")
      local toggle_hidden = lga_actions.toggle_flag
        or function(flag)
          return function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local picker = action_state.get_current_picker(prompt_bufnr)
            local prompt = picker:_get_prompt()
            actions.close(prompt_bufnr)
            telescope.extensions.live_grep_args.live_grep_args({ default_text = prompt .. " " .. flag })
          end
        end

      local function file_finder(hidden)
        if vim.fn.executable("fd") == 1 then
          if hidden then
            return { "fd", "--type", "f", "--hidden", "--no-ignore", "--strip-cwd-prefix" }
          end
          return { "fd", "--type", "f", "--strip-cwd-prefix" }
        end
        if hidden then
          return { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!.git" }
        end
        return { "rg", "--files", "--glob", "!.git" }
      end

      local function dynamic_preview_width(_, cols, _)
        local ft = vim.bo[vim.api.nvim_get_current_buf()].filetype
        local wide = { c = true, cpp = true, go = true, rust = true, lua = true, python = true, javascript = true, typescript = true }
        if cols < 140 then
          return 0.5
        end
        return wide[ft] and 0.65 or 0.55
      end

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = "🔍 ",
        selection_caret = "› ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.9,
          height = 0.82,
          prompt_position = "top",
          preview_width = dynamic_preview_width,
          preview_cutoff = 80,
        },
        results_title = false,
        preview_title = false,
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-f>"] = function(prompt_bufnr)
              actions.close(prompt_bufnr)
              telescope.extensions.live_grep_args.live_grep_args()
            end,
          },
        },
      })
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = {
        previewer = false,
        prompt_title = "文件搜索",
        find_command = file_finder(false),
        mappings = {
          i = {
            ["<C-h>"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local picker = action_state.get_current_picker(prompt_bufnr)
              local prompt = picker:_get_prompt()
              actions.close(prompt_bufnr)
              builtin.find_files({
                find_command = file_finder(true),
                hidden = true,
                no_ignore = true,
                default_text = prompt,
              })
            end,
          },
        },
      }
      opts.pickers.live_grep = { prompt_title = "全局搜索" }
      opts.extensions = opts.extensions or {}
      opts.extensions.live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-l>"] = toggle_hidden("--hidden"),
          },
        },
      }
      return opts
    end,
  },
}
