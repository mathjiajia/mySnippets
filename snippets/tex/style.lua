local snips, autosnips = {}, {}

local postfix = require("luasnip.extras.postfix").postfix
local tex = require("mySnippets.latex")

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

local postfix_math_specs = {
	mbb = {
		context = { name = "mathbb", dscr = "math blackboard bold" },
		command = { pre = [[\mathbb{]], post = [[}]] },
	},
	mcal = {
		context = { name = "mathcal", dscr = "math calligraphic" },
		command = { pre = [[\mathcal{]], post = [[}]] },
	},
	mscr = {
		context = { name = "mathscr", dscr = "math script" },
		command = { pre = [[\mathscr{]], post = [[}]] },
	},
	mfr = {
		context = { name = "mathfrak", dscr = "mathfrak" },
		command = { pre = [[\mathfrak{]], post = [[}]] },
	},
	hat = {
		context = { name = "hat", dscr = "hat" },
		command = { pre = [[\widehat{]], post = [[}]] },
	},
	bar = {
		context = { name = "bar", dscr = "bar (overline)" },
		command = { pre = [[\overline{]], post = [[}]] },
	},
	td = {
		context = { name = "tilde", priority = 500, dscr = "tilde" },
		command = { pre = [[\widetilde{]], post = [[}]] },
	},
}

local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(nil, fmta([[<><><><>]], { t(user_arg1), t(capture), t(user_arg2), i(0) }))
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(nil, fmta([[<><><><>]], { t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }))
	end
end

local postfix_snippet = function(context, command)
	context.dscr = context.dscr
	context.name = context.dscr
	context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
	return postfix(
		context,
		{ d(1, dynamic_postfix, {}, { user_args = { command.pre, command.post } }) },
		{ condition = tex.in_math }
	)
end

local postfix_math_snippets = {}
for k, v in pairs(postfix_math_specs) do
	table.insert(
		postfix_math_snippets,
		postfix_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command)
	)
end
vim.list_extend(autosnips, postfix_math_snippets)

return snips, autosnips
