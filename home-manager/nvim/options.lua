opt = {
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
  --background = "dark",
  signcolumn = "yes",
  mouse = "a",
  cursorline = true,
  backspace = "indent,eol,start",
  clipboard = "unnamedplus",
  splitright = true,
  splitbelow = true,
  swapfile = false,
}

for k,v in pairs(opt) do
  vim.opt[k] = v
end

vim.g.mapleader = " "
