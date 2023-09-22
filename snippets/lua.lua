local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin }

snips = {
	s(
		{ trig = "M", name = "Module decl.", desc = "Declare a lua module" },
		fmta(
			[[
			local M = {}
			<>
			return M
			]],
			{ i(0) }
		),
		opts
	),
	s(
		{ trig = "lreq", name = "local require", desc = "Require module as a variable" },
		fmta([[local <> = require("<>")]], { dl(2, l._1:match("%.([%w_]+)$")), i(1) }),
		opts
	),
}

return snips
