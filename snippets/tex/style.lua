local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

local opts = { condition = tex.in_math, show_condition = tex.in_text }
local opts2 = { condition = tex.in_text, show_condition = tex.in_text }

-- Dynamically generates snippets based on matched postfix.
local function dynamic_postfix(_, parent, _, arg1, arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(nil, fmta([[<><><><>]], { t(arg1), t(capture), t(arg2), i(0) }))
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(nil, fmta([[<><><><>]], { t(arg1), i(1, visual_placeholder), t(arg2), i(0) }))
	end
end

local function postfix_snippet(context, cmd)
	context.name = context.desc
	context.docstring = cmd.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. cmd.post
	return postfix(context, { d(1, dynamic_postfix, {}, { user_args = { cmd.pre, cmd.post } }) }, opts)
end

snips = {
	s({ trig = "bf", name = "bold", desc = "Insert bold text." }, { t("\\textbf{"), i(1), t("}") }, opts2),
	s({ trig = "it", name = "italic", desc = "Insert italic text." }, { t("\\textit{"), i(1), t("}") }, opts2),
	s({ trig = "em", name = "emphasize", desc = "Insert emphasize text." }, { t("\\emph{"), i(1), t("}") }, opts2),
}

autosnips = {
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
		context = { name = "mathbb", desc = "math blackboard bold" },
		command = { pre = [[\mathbb{]], post = [[}]] },
	},
	mcal = {
		context = { name = "mathcal", desc = "math calligraphic" },
		command = { pre = [[\mathcal{]], post = [[}]] },
	},
	mscr = {
		context = { name = "mathscr", desc = "math script" },
		command = { pre = [[\mathscr{]], post = [[}]] },
	},
	mfr = {
		context = { name = "mathfrak", desc = "mathfrak" },
		command = { pre = [[\mathfrak{]], post = [[}]] },
	},
	hat = {
		context = { name = "hat", desc = "hat", priority = 500 },
		command = { pre = [[\widehat{]], post = [[}]] },
	},
	bar = {
		context = { name = "bar", desc = "bar (overline)", priority = 500 },
		command = { pre = [[\overline{]], post = [[}]] },
	},
	td = {
		context = { name = "tilde", desc = "tilde", priority = 500 },
		command = { pre = [[\widetilde{]], post = [[}]] },
	},
}

local postfix_math_snippets = {}
for k, v in pairs(postfix_math_specs) do
	table.insert(
		postfix_math_snippets,
		postfix_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command)
	)
end
vim.list_extend(autosnips, postfix_math_snippets)

return snips, autosnips
