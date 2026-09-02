-- Collection of small QoL modules. Only the modules listed under `opts` are
-- enabled; picker/explorer stay off because Telescope and neo-tree cover them.
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true }, -- disable heavy features on huge files
		quickfile = { enabled = true }, -- render the file before plugins load when opening `nvim file`
		notifier = { enabled = true }, -- pretty vim.notify with a history
		lazygit = { enabled = true }, -- floating lazygit, themed to match the colorscheme
		gitbrowse = { enabled = true }, -- open current file/line on GitHub
	},
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazy[g]it" },
		{ "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit [L]og (repo)" },
		{ "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit log current [F]ile" },
		{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git [B]lame line" },
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git [B]rowse on remote", mode = { "n", "v" } },
		{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
		{ "<leader>nd", function() Snacks.notifier.hide() end, desc = "[N]otifications [D]ismiss" },
	},
}
