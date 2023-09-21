local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local sec_specs = {
	cha = "chapter",
	sec = "section",
	ssec = "section*",
	sub = "subsection",
	ssub = "subsection*",
}

local sec_snippet = function(context, sec, opts)
	context.name = sec
	context.dscr = sec
	return s(
		context,
		fmta(
			[[
			\<>{<>}\label{<>:<>}
			<>
			]],
			{ t(sec), i(1), t(context.trig), l(l._1:gsub("[^%w]+", "_"):gsub("_*$", ""):lower(), 1), i(0) }
		),
		opts
	)
end

local env_snippets = {}

for k, v in pairs(sec_specs) do
	table.insert(
		env_snippets,
		sec_snippet(
			{ trig = k },
			v,
			{ condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }
		)
	)
end

vim.list_extend(snips, env_snippets)

return snips
