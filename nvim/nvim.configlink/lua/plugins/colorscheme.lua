return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			styles = {
				comments = { italic = false }, -- Disable italics in comments
			},
			on_highlights = function(hl, c)
				-- Mute markdown highlighting: the groups are scoped to
				-- .markdown/.markdown_inline so other filetypes (help, vimdoc, ...)
				-- keep the theme's full @markup styling.
				hl["@markup.heading.markdown"] = { bold = true }
				for i = 1, 6 do
					hl["@markup.heading." .. i .. ".markdown"] = { bold = true }
				end
				hl["@markup.strong.markdown_inline"] = { bold = true }
				hl["@markup.italic.markdown_inline"] = { italic = true }
				hl["@markup.raw.markdown_inline"] = { fg = c.teal } -- inline `code`: colored text, no background
				for _, group in ipairs({
					"@markup.link.markdown_inline",
					"@markup.link.label.markdown_inline",
					"@markup.link.url.markdown_inline",
					"@markup.list.markdown",
					"@markup.quote.markdown",
					"@punctuation.special.markdown", -- #, >, list markers
				}) do
					hl[group] = {}
				end
			end,
		})

		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
