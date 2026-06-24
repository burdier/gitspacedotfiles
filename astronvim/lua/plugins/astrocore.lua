-- Config base de AstroNvim/AstroCore
-- Pensado para Codespaces y terminal remota.

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        number = true,
        relativenumber = true,
        tabstop = 2,
        shiftwidth = 2,
        expandtab = true,
        smartindent = true,
        wrap = false,
        scrolloff = 8,
        sidescrolloff = 8,
        clipboard = "unnamedplus",
      },
      g = {
        mapleader = " ",
        maplocalleader = ",",
      },
    },
    mappings = {
      n = {
        ["<leader>w"] = { "<cmd>w<cr>", desc = "Guardar archivo" },
        ["<leader>q"] = { "<cmd>q<cr>", desc = "Cerrar ventana" },
        ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Explorer" },
        ["<leader>nh"] = { "<cmd>nohlsearch<cr>", desc = "Limpiar búsqueda" },
      },
    },
  },
}
