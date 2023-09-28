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

local function commit_snippet(trig)
	local context = {
		trig = trig,
		name = trig,
		desc = "git commit " .. trig,
		condition = conds_expand.line_begin,
		show_condition = pos.line_begin,
	}
	return s(context, fmta([[<>(<>): <>]], { t(context.trig), i(1, "scope"), i(0, "title") }))
end

for _, v in ipairs(commit_specs) do
	table.insert(snips, commit_snippet(v))
end

return snips
