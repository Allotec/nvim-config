--- Close the first window displaying a buffer with a given name
--- @param name string: The buffer (tab) name to close
function CloseWindowByBufferName(name)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if bufname == name then
      vim.api.nvim_set_current_win(win)
      vim.cmd "close"
      return
    end
  end
  -- vim.notify("No window with buffer name: " .. name, vim.log.levels.WARN)
end

--- Open a buffer by (file) name in a horizontal split below the current window
function OpenBufferBelowByName(name)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
    if bufname == name then
      -- Check if buffer is already visible in any window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          return -- Already open, do nothing
        end
      end
      local cur_win = vim.api.nvim_get_current_win()
      vim.cmd "split"
      vim.api.nvim_win_set_buf(0, bufnr)
      vim.api.nvim_set_current_win(cur_win)
      return
    end
  end
end

---@type LazySpec
return {
  {
    "Allotec/projectmgr.nvim",
    lazy = false,
    opts = {
      session = {
        enabled = false,
      },
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>P"] = { "<Cmd>ProjectMgr<CR>", desc = "Open ProjectMgr panel" },
            },
          },
        },
      },
    },
  },

  {
    "ej-shafran/compile-mode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- if you want to enable coloring of ANSI escape codes in compilation output, add:
      { "m00qek/baleia.nvim" },
    },
    config = function()
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        -- to add ANSI escape code support, add:
        baleia_setup = true,
        environment = {
          CLICOLOR_FORCE = "yes", -- to enable colored output in cargo commands
          TERM = "xterm-256color", -- to set the terminal type
          CARGO_TERM_COLOR = "always", -- to enable colored output in cargo commands
        },
        default_command = "",
        ask_about_save = false,

        -- to make `:Compile` replace special characters (e.g. `%`) in
        -- the command (and behave more like `:!`), add:
        -- bang_expansion = true,
      }

      vim.keymap.set("n", "<leader>A", ":silent Compile<CR>", { desc = "Run Compile command silently" })
      vim.keymap.set("n", "<leader>C", ":silent Recompile<CR>", { desc = "Run Compile command silently" })

      vim.keymap.set(
        "n",
        "<C-c>",
        function() CloseWindowByBufferName "*compilation*" end,
        { desc = "Close window by buffer name" }
      )

      vim.keymap.set(
        "n",
        "<C-x>",
        function() OpenBufferBelowByName "*compilation*" end,
        { desc = "Open window by buffer name" }
      )
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {},
    -- See Commands section for default commands if you want to lazy load on the m
  },

  -- == Examples of Adding Plugins ==
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside o f the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the d efault astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- includ e the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
