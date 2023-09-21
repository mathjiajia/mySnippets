local snips, autosnips = {}, {}

local postfix = require("luasnip.extras.postfix").postfix
local tex = require("mySnippets.latex")

local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), t(capture), t(user_arg2), i(0) }
			)
		)
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }
			)
		)
	end
end

snips = {
	s(
		{ trig = "bf", name = "bold", dscr = "Insert bold text." },
		{ t("\\textbf{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "it", name = "italic", dscr = "Insert italic text." },
		{ t("\\textit{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "em", name = "emphasize", dscr = "Insert emphasize text." },
		{ t("\\emph{"), i(1), t("}") },
		{ condition = tex.in_text, show_condition = tex.in_text }
	),
}

autosnips = {
	postfix(
		{ trig = "bar", name = "post overline", hidden = true },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\overline{", "}" } }) },
		{ condition = tex.in_math }
	),
	postfix(
		{ trig = "hat", name = "post widehat", hidden = true },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\widehat{", "}" } }) },
		{ condition = tex.in_math }
	),
	postfix(
		{ trig = "td", name = "post widetilde", hidden = true },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\widetilde{", "}" } }) },
		{ condition = tex.in_math }
	),

	s({ trig = "quad", name = "quad", hidden = true }, { t("\\quad ") }, { condition = tex.in_math }),
	s(
		{ trig = "tt", name = "text", wordTrig = false, hidden = true },
		{ t("\\text{"), i(1), t("}") },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "tss", name = "text subscript", wordTrig = false, hidden = true },
		{ t("_{\\mathrm{"), i(1), t("}}") },
		{ condition = tex.in_math }
	),
	-- s(
	-- 	{ trig = '[^\\]"', name = 'Quotation', regTrig = true },
	-- 	{ t('``'), i(1), t "''" },
	-- 	{ condition = tex.in_text }
	-- ),
}

return snips, autosnips
