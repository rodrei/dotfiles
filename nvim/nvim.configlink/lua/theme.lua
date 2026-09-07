-- Applies the color theme selected with the `theme` CLI (bin/theme in the
-- dotfiles). The CLI copies the chosen palette to ~/.config/theme/palette.conf;
-- this module reads it, picks the matching colorscheme, and layers the
-- theme-independent highlight tweaks on top.
local M = {}

local palette_file = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/theme/palette.conf"

local function read_palette()
	local f = io.open(palette_file, "r")
	if not f then
		return nil
	end
	local p = {}
	for line in f:lines() do
		local key, value = line:match("^([%w_]+)=(.*)$")
		if key then
			p[key] = value
		end
	end
	f:close()
	return p
end

-- Highlight tweaks that should survive whichever colorscheme is active, so
-- they are (re)applied on every ColorScheme event.
local function install_overrides(p)
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("theme-overrides", { clear = true }),
		callback = function()
			local hl = function(group, val)
				vim.api.nvim_set_hl(0, group, val)
			end

			-- Mute markdown highlighting: the groups are scoped to
			-- .markdown/.markdown_inline so other filetypes (help, vimdoc, ...)
			-- keep the theme's full @markup styling.
			hl("@markup.heading.markdown", { bold = true })
			for i = 1, 6 do
				hl("@markup.heading." .. i .. ".markdown", { bold = true })
			end
			hl("@markup.strong.markdown_inline", { bold = true })
			hl("@markup.italic.markdown_inline", { italic = true })
			hl("@markup.raw.markdown_inline", { fg = p.color6 }) -- inline `code`: colored text, no background
			for _, group in ipairs({
				"@markup.link.markdown_inline",
				"@markup.link.label.markdown_inline",
				"@markup.link.url.markdown_inline",
				"@markup.list.markdown",
				"@markup.quote.markdown",
				"@punctuation.special.markdown", -- #, >, list markers
			}) do
				hl(group, {})
			end

			-- Some palettes share one colorscheme (e.g. selenized black/white
			-- reuse selenized dark/light) and only differ in the background.
			if p.nvim_bg_from_palette == "true" then
				for _, group in ipairs({ "Normal", "NormalNC" }) do
					local current = vim.api.nvim_get_hl(0, { name = group })
					current.bg = p.background
					hl(group, current)
				end
			end
		end,
	})
end

function M.apply()
	local p = read_palette() or {}
	vim.o.termguicolors = true
	vim.o.background = p.background_mode or "dark"
	install_overrides(p)

	local scheme = p.nvim_colorscheme or "selenized"
	if not pcall(vim.cmd.colorscheme, scheme) then
		vim.notify(("theme: colorscheme %q is not installed, using default"):format(scheme), vim.log.levels.WARN)
		vim.cmd.colorscheme("default")
	end
end

return M
