-- AstroCommunity imports
-- Docs: https://docs.astronvim.com/

return {
  "AstroNvim/astrocommunity",

  -- Tema
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- Lenguajes / stacks comunes
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.bash" },
}
