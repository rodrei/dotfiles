return { -- Live markdown preview in the web browser
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		-- Style the preview like a Claude artifact. Must be set before the
		-- plugin loads, and the plugin wants an absolute path.
		vim.g.mkdp_markdown_css = vim.fs.joinpath(vim.fn.stdpath("config"), "css", "claude-artifact.css")
	end,
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "[M]arkdown [P]review toggle (browser)" },
	},
}
