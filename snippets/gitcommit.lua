local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")

local commit_specs = {
	"feat",
	"fix",
	"chore",
	"revert",
	"refactor",
	"cleanup",
}

local commit_snippet = function(context)
	context.name = context.trig
	context.desc = context.trig
	return s(
		context,
		fmta([[<>(<>): <>]], { t(context.trig), i(1, "scope"), i(0, "title") }),
		{ condition = conds_expand.line_begin, show_condition = pos.line_begin }
	)
end

for _, v in ipairs(commit_specs) do
	table.insert(snips, commit_snippet({ trig = v }))
end

return snips
