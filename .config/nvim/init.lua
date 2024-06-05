-- [[ A minimal configuration modified from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua ]]
-- [[ Essential keymaps ]]
-- Set <space> as the leader key.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap some keys
vim.cmd [[nnoremap H ^]]
vim.cmd [[nnoremap L $]]

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

vim.o.tabstop = 2 -- size of a hard tabstop (ts).
vim.o.shiftwidth = 2 -- size of an indentation (sw).
vim.o.expandtab = true -- always uses spaces instead of tab characters (et).
vim.o.softtabstop = 2 -- number of spaces a <Tab> counts for. When 0, feature is off (sts).

vim.o.pumheight = 10 -- limit popup height
vim.o.number = true -- display line number

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Setup plugins ]]
require("lazy").setup("plugins")

-- [[ Set theme ]]
vim.g.moonflyItalics = false
vim.cmd [[colorscheme moonfly]]

