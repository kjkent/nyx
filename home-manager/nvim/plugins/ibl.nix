{ config, pkgs, ... }: let
  color = config.stylix.base16Scheme;
in {
  config = {
    programs.neovim = {
      plugins = [ pkgs.vimPlugins.indent-blankline-nvim ];
      extraLuaConfig = ''
        local highlight = { "a", "b", "c", "d", "e", "f", "g" }

        vim.api.nvim_set_hl(0, "a", { fg = "#${color.base01}" })
        vim.api.nvim_set_hl(0, "b", { fg = "#${color.base02}" })
        vim.api.nvim_set_hl(0, "c", { fg = "#${color.base03}" })
        vim.api.nvim_set_hl(0, "d", { fg = "#${color.base04}" })
        vim.api.nvim_set_hl(0, "e", { fg = "#${color.base05}" })
        vim.api.nvim_set_hl(0, "f", { fg = "#${color.base06}" })
        vim.api.nvim_set_hl(0, "g", { fg = "#${color.base07}" })

        require("ibl").setup { indent = { highlight = highlight } }
      '';
    };
  };
}



