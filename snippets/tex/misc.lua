local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")

local opts = { condition = tex.in_text }
local opts2 = { condition = tex.in_text }

local function appended_space_after_insert()
	vim.api.nvim_create_autocmd("InsertCharPre", {
		callback = function()
			if string.find(vim.v.char, "%a") then
				vim.v.char = " " .. vim.v.char
			end
		end,
		buffer = 0,
		once = true,
		desc = "Auto Add a Space after Inline Math",
	})
end

local function surroundWithInlineMath(prefix, content, suffix)
	return prefix .. "\\(" .. content .. "\\)" .. suffix
end

autosnips = {
	s({
		trig = "(%s)([b-zB-HJ-Z0-9])([,;.%-%)]?)%s+",
		name = "single-letter variable",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return snip.captures[1] .. "\\(" .. snip.captures[2] .. "\\)" .. snip.captures[3]
		end, {}),
	}, opts),

	s({
		trig = "(%s)([0-9]+[a-zA-Z]+)([,;.%)]?)%s+",
		name = "surround word starting with number",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return surroundWithInlineMath(snip.captures[1], snip.captures[2], snip.captures[3])
		end, {}),
	}, opts),

	s({
		trig = "(%s)(%w[-_+=><]%w)([,;.%)]?)%s+",
		name = "surround i+1",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return surroundWithInlineMath(snip.captures[1], snip.captures[2], snip.captures[3])
		end, {}),
	}, opts),

	s(
		{
			trig = "mk",
			name = "inline math",
			desc = "Insert inline Math Environment.",
			hidden = true,
			condition = tex.in_text,
		},
		fmt([[\({}\){}]], { i(1), i(0) }),
		{
			callbacks = {
				[-1] = {
					[events.leave] = appended_space_after_insert,
				},
			},
		}
	),
	s(
		{
			trig = "dm",
			name = "dispaly math",
			desc = "Insert display Math Environment.",
		},
		fmt(
			[[
			\[
				{}
			\]{}
			]],
			{ i(1), i(0) }
		),
		opts2
	),
	s({
		trig = "pha",
		name = "phantom",
		desc = "create a space",
		hidden = true,
		condition = conds_expand.line_begin * tex.in_align,
	}, { t("&\\phantom{\\;=\\;} ") }),

	s({
		trig = "ni",
		name = "non-indented paragraph",
		desc = "Insert non-indented paragraph.",
	}, { t({ "\\noindent", "" }) }, opts2),
}

return nil, autosnips
