{ pkgs, ... }:
{
  imports = [ ./plugins ];
  config = {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
          xclip
          wl-clipboard
        ];
        extraLuaConfig = ''
          vim_opt = {
            number = true,
            relativenumber = true,
            tabstop = 2,
            shiftwidth = 2,
            expandtab = true,
            autoindent = true,
            wrap = false,
            ignorecase = true,
            smartcase = true,
            termguicolors = true,
            signcolumn = "yes",
            mouse = "a",
            cursorline = true,
            backspace = "indent,eol,start",
            clipboard = "unnamedplus",
            splitright = true,
            splitbelow = true,
            swapfile = false,
          }

          vim_g = {
            mapleader = " ",
          }

          for k,v in pairs(vim_opt) do
            vim.opt[k] = v
          end

          for k,v in pairs(vim_g) do
            vim.g[k] = v
          end

          -- prefixes = s:split  t:tab
          -- suffixes = c:create p:prev n:next q:quit
          local keymap = vim.keymap
          keymap.set("n", "<leader>qh", ":nohl<CR>",         { desc = "Clear search highlights"        })
          -- window management
          keymap.set("n", "<leader>sv", "<C-w>v",            { desc = "Split window vertically"        })
          keymap.set("n", "<leader>sh", "<C-w>s",            { desc = "Split window horizontally"      })
          keymap.set("n", "<leader>se", "<C-w>=",            { desc = "Make splits equal size"         })
          keymap.set("n", "<leader>sq", "<cmd>close<CR>",    { desc = "Close current split"            })
          keymap.set("n", "<leader>tc", "<cmd>tabnew<CR>",   { desc = "Open new tab"                   })
          keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab"              })
          keymap.set("n", "<leader>tn", "<cmd>tabn<CR>",     { desc = "Go to next tab"                 })
          keymap.set("n", "<leader>tp", "<cmd>tabp<CR>",     { desc = "Go to previous tab"             })
          keymap.set("n", "<leader>tN", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
        '';
      };
    };
  };
}
