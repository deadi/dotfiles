-- Theme: use the Omarchy theme file if this machine has Omarchy,
-- otherwise fall back to tokyonight (e.g. Ubuntu server).
-- This used to be a symlink into ~/.local/state/omarchy, which dangles on hosts without Omarchy.
local f = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
if vim.uv.fs_stat(f) then
	return dofile(f)
end

return {
	{ "folke/tokyonight.nvim", priority = 1000 },
	{ "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },
}
