-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.zig" },
  -- { import = "astrocommunity.pack.cs" },

  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.cmake" },

  -- { import = "astrocommunity.lsp.nvim-lsp-endhints" },

  { import = "astrocommunity.utility.telescope-coc-nvim" },
  { import = "astrocommunity.utility.telescope-fzy-native-nvim" },
  { import = "astrocommunity.markdown-and-latex.peek-nvim" },
  -- { import = "astrocommunity.completion.copilot-lua" },
  -- { -- further customize the options set by the community
  --   "copilot.lua",
  --   opts = {
  --     suggestion = {
  --       keymap = {
  --         accept = "<C-l>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<C-.>",
  --         prev = "<C-,>",
  --         dismiss = "<C/>",
  --       },
  --     },
  --   },
  -- },
}
