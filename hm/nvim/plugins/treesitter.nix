{pkgs, ...}: {
  config = {
    programs.neovim = {
      plugins = [pkgs.vimPlugins.nvim-treesitter.withAllGrammars];
      extraLuaConfig = ''
        require('nvim-treesitter.configs').setup {
          ensure_installed = {},
          auto_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        }
      '';
    };
  };
}
