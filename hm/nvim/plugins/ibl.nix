{ config, pkgs, ... }: {
  config = {
    programs.neovim = {
      plugins = [ pkgs.vimPlugins.indent-blankline-nvim ];
      extraLuaConfig = with config.lib.stylix.colors; ''
        local highlight = { "a", "b", "c", "d", "e", "f", "g" }

        vim.api.nvim_set_hl(0, "a", { fg = "#${base01}" })
        vim.api.nvim_set_hl(0, "b", { fg = "#${base02}" })
        vim.api.nvim_set_hl(0, "c", { fg = "#${base03}" })
        vim.api.nvim_set_hl(0, "d", { fg = "#${base04}" })
        vim.api.nvim_set_hl(0, "e", { fg = "#${base05}" })
        vim.api.nvim_set_hl(0, "f", { fg = "#${base06}" })
        vim.api.nvim_set_hl(0, "g", { fg = "#${base07}" })

        require("ibl").setup { indent = { highlight = highlight } }
      '';
    };
  };
}
