{pkgs, ...}: {
  config = {
    programs.neovim = {
      plugins = [ pkgs.vimPlugins.alpha-nvim ];
      extraLuaConfig = ''
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        
        -- Set header
        dashboard.section.header.val = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "                                                     ",
        }
        
        -- Set menu
        dashboard.section.buttons.val = {
          dashboard.button("e", "  > New File", "<Cmd>ene<CR>"),
          dashboard.button("-", "  > Toggle file explorer", "<Cmd>Oil<CR>"),
          dashboard.button("q", "  > Quit NVIM", "<Cmd>qa<CR>"),
        }
        
        -- Send config to alpha
        alpha.setup(dashboard.opts)
        
        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
      '';
    };
  };
}
