local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

snips = {
	s(
		{ trig = "/", name = "fraction", dscr = "Insert a fraction notation.", wordTrig = false, hidden = true },
		fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
}

autosnips = {
	s({ trig = "([hH])_(%d)(%u)", name = "cohomology-d", regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "^{" .. snip.captures[2] .. "}(" .. snip.captures[3] .. ","
		end, {}),
		i(1),
		t(")"),
		i(0),
	}, { condition = tex.in_math }),

	s({ trig = "(%a)p(%d)", name = "x[n+1]", regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{n+" .. snip.captures[2] .. "}"
		end, {}),
	}, { condition = tex.in_math }),

	s(
		{ trig = "dint", name = "integral", dscr = "Insert integral notation.", hidden = true },
		{ t("\\int_{"), i(1, "-\\infty"), t("}^{"), i(2, "\\infty"), t("} ") },
		{ condition = tex.in_math }
	),

	s(
		{ trig = "(%w)//", name = "fraction with a single numerator", regTrig = true, hidden = true },
		fmta([[\frac{<>}{<>}<>]], { f(function(_, snip)
			return snip.captures[1]
		end), i(1), i(0) }),
		{ condition = tex.in_math }
	),

	-- fractions
	s(
		{ trig = "//", name = "fraction", dscr = "fraction (general)" },
		fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "(%d+)/", name = "fraction", dscr = "auto fraction 1", regTrig = true, hidden = true },
		fmta([[\frac{<>}{<>}<>]], { f(function(_, snip)
			return snip.captures[1]
		end), i(1), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),

	s(
		{ trig = "lim", name = "lim(sup|inf)", dscr = "lim(sup|inf)" },
		fmta([[\lim<><><>]], {
			c(1, { t(""), t("sup"), t("inf") }),
			c(2, { t(""), fmta([[_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }) }),
			i(0),
		}),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "sum", name = "summation", dscr = "summation" },
		fmta([[\sum<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "prod", name = "product", dscr = "product" },
		fmta([[\prod<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "cprod", name = "coproduct", dscr = "coproduct" },
		fmta([[\coprod<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "set", name = "set", dscr = "set" },
		fmta([[\{<>\}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "nnn", name = "bigcap", dscr = "bigcap" },
		fmta([[\bigcap<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "uuu", name = "bigcup", dscr = "bigcup" },
		fmta([[\bigcup<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "bnc", name = "binomial", dscr = "binomial (nCR)" },
		fmta([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),

	s(
		{ trig = "ses", name = "short exact sequence", hidden = true },
		fmta(
			[[<>\\longrightarrow <>\\longrightarrow <>\\longrightarrow <>]],
			{ c(1, { t("0"), t("1") }), i(2), i(3), i(4), rep(1) }
		),
		{ condition = tex.in_math }
	),

	s({ trig = "([hH])([i-npq])(%u)", name = "cohomology-a", regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "^{" .. snip.captures[2] .. "}(" .. snip.captures[3] .. ","
		end, {}),
		i(1),
		t(")"),
		i(0),
	}, { condition = tex.in_math }),

	s(
		{ trig = "rij", name = "(x_n) n ∈ N", hidden = true },
		{ t("("), i(1, "x"), t("_"), i(2, "n"), t(")_{"), rep(2), t("\\in "), i(3, "\\mathbb{N}"), t("}") },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "rg", name = "i = 1, ..., n", hidden = true },
		{ i(1, "i"), t(" = "), i(2, "1"), t(" \\dots, "), i(0, "n") },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "ls", name = "a_1, ..., a_n", hidden = true },
		{ i(1, "a"), t("_{"), i(2, "1"), t("}, \\dots, "), rep(1), t("_{"), i(3, "n"), t("}") },
		{ condition = tex.in_math }
	),
}

local operator_specs = {
	"cod",
	"coker",
	"int",
	"arcsin",
	"sin",
	"arccos",
	"cos",
	"arctan",
	"tan",
	"cot",
	"csc",
	"sec",
	"log",
	"abs",
	"ast",
	"deg",
	"det",
	"dim",
	"exp",
	"hom",
	"inf",
	"ker",
	"max",
	"min",
	"perp",
	"star",
}

local operator_snippet = function(context)
	context.name = context.trig
	context.dscr = context.trig .. " with automatic backslash"
	return s(context, t([[\]] .. context.trig), { condition = tex.in_math })
end

local operator_snippets = {}
for _, v in ipairs(operator_specs) do
	table.insert(operator_snippets, operator_snippet({ trig = v }))
end
vim.list_extend(autosnips, operator_snippets)

return snips, autosnips
