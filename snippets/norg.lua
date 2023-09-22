local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")

local opts = { condition = conds_expand.line_begin }

snips = {
	s({
		trig = "([%*>~%-])([2-6])",
		name = "Heading, Quote, List",
		desc = "Add Heading",
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.rep(snip.captures[1], tonumber(snip.captures[2], 10)) .. " "
		end, {}),
	}, opts),

	s(
		{ trig = "link", name = "Neorg Links", desc = "Insert a Link" },
		fmta([[{<>}[<>]<>]], { i(1, "url"), i(2, "title"), i(0) })
	),
}

local block_specs = {
	code = true,
	embed = true,
	image = true,
	date = false,
	math = false,
	table = false,
}

local function block_snippet(context, labeled)
	context.name = context.trig
	context.desc = context.trig .. " block"

	if labeled then
		return s(
			context,
			{ t("@"), t(context.name), t(" "), i(1), t({ "", "\t" }), i(0), t({ "", "@end" }) },
			{ condition = conds_expand.line_begin }
		)
	else
		return s(
			context,
			{ t("@"), t(context.name), t({ "", "\t" }), i(0), t({ "", "@end" }) },
			{ condition = conds_expand.line_begin }
		)
	end
end

local block_snippets = {}
for k, v in pairs(block_specs) do
	table.insert(block_snippets, block_snippet({ trig = k }, v))
end

vim.list_extend(snips, block_snippets)

autosnips = {
	s({ trig = ";b", name = "bold" }, fmta([[*<>*<>]], { i(1), i(0) })),
	s({ trig = ";i", name = "italic" }, fmta([[/<>/<>]], { i(1), i(0) })),
	s({ trig = ";u", name = "underline" }, fmta([[_<>_<>]], { i(1), i(0) })),
	s({ trig = ";s", name = "strikethrough" }, fmta([[-<>-<>]], { i(1), i(0) })),
	s({ trig = ";|", name = "spoiler" }, fmta([[|<>|<>]], { i(1), i(0) })),
	s({ trig = ";c", name = "inline code" }, fmta([[`<>`<>]], { i(1), i(0) })),
	s({ trig = ";^", name = "subscript" }, fmta([[^<>^<>]], { i(1), i(0) })),
	s({ trig = ";_", name = "subscript" }, fmta([[,<>,<>]], { i(1), i(0) })),
	s({ trig = "mk", name = "inline math" }, fmta([[$<>$<>]], { i(1), i(0) })),
	s({ trig = ";v", name = "variable" }, fmta([[=<>=<>]], { i(1), i(0) })),
	s({ trig = ";+", name = "comment" }, fmta([[+<>+<>]], { i(1), i(0) })),
}

return snips, autosnips
