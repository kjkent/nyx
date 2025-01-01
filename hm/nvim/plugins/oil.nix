{pkgs, ...}: {
  config = {
    programs.neovim = {
      plugins = [pkgs.vimPlugins.oil-nvim];
      extraLuaConfig = ''
        local keymap = vim.keymap
        keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

        require("oil").setup({
          default_file_explorer = true,
          columns = { "icon", "permissions", "size" },
          delete_to_trash = false,
          constrain_cursor = "name",
          experimental_watch_for_changes = true,
          natural_order = true,
        })
      '';
    };
  };
}
