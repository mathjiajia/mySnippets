local snips = {}

local context = require("mySnippets.context")
local username = vim.env.USER:gsub("^%l", string.upper)

snips = {
	s({ trig = "todo", name = "TODO", dscr = "TODO:" }, {
		t("TODO(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "fix", name = "FIXME", dscr = "FIXME:" }, {
		t("FIXME(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "hack", name = "HACK", dscr = "HACK:" }, {
		t("HACK(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "note", name = "NOTE", dscr = "NOTE:" }, {
		t("NOTE(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),
}

return snips
