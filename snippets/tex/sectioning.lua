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

local function sec_snippet(trig, sec)
	local context = {
		trig = trig,
		name = sec,
		desc = sec,
		condition = conds_expand.line_begin * tex.in_text,
		show_condition = pos.line_begin * tex.in_text,
	}
	return s(
		context,
		fmta(
			[[
			\<>{<>}\label{<>:<>}

			<>
			]],
			{ t(sec), i(1), t(trig), l(l._1:gsub("[^%w]+", "_"):gsub("_*$", ""):lower(), 1), i(0) }
		)
	)
end

for k, v in pairs(sec_specs) do
	table.insert(snips, sec_snippet(k, v))
end

return snips
