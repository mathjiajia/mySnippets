local autosnips = {}

local tex = require("mySnippets.latex")

autosnips = {
	s({ trig = "rmap", name = "rational map arrow", wordTrig = false, hidden = true }, {
		d(1, function()
			if tex.in_xymatrix() then
				return sn(nil, { t({ "\\ar@{-->}[" }), i(1), t({ "]" }) })
			else
				return sn(nil, { t("\\dashrightarrow ") })
			end
		end),
	}, { condition = tex.in_math }),

	s({ trig = "emb", name = "embeddeing map arrow", wordTrig = false, hidden = true }, {
		d(1, function()
			if tex.in_xymatrix() then
				return sn(nil, { t({ "\\ar@{^{(}->}[" }), i(1), t({ "]" }) })
			else
				return sn(nil, { t("\\hookrightarrow ") })
			end
		end),
	}, { condition = tex.in_math }),
}

return nil, autosnips
