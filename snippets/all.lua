local snips = {}

local context = require("mySnippets.context")
local username = vim.env.USER:gsub("^%l", string.upper)

snips = {
	s({ trig = "todo", name = "TODO", dscr = "TODO:" }, {
		t("TODO(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "fix", name = "FIX", dscr = "FIX:" }, {
		c(1, {
			t("FIXME"),
			t("BUG"),
		}),
		t("(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "hack", name = "HACK", dscr = "HACK:" }, {
		c(1, {
			t("HACK"),
			t("WARNING"),
		}),
		t("(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),

	s({ trig = "note", name = "NOTE", dscr = "NOTE:" }, {
		c(1, {
			t("NOTE: "),
			t("XXX: "),
		}),
		t("(" .. username .. "): "),
	}, { condition = context.in_comments, show_condition = context.in_comments }),
}

return snips
