-- One colorscheme plugin per theme family under theme/themes. They all lazy-load:
-- lazy.nvim pulls in the right one when lua/theme.lua runs `:colorscheme`.
return {
	{ "calind/selenized.nvim", lazy = true },
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			styles = {
				comments = { italic = false },
			},
		},
	},
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true, opts = {} },
}
