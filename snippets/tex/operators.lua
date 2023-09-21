local autosnips = {}

local tex = require("mySnippets.latex")

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

	s({ trig = "(%w)//", name = "fraction with a single numerator", regTrig = true, hidden = true }, {
		t("\\frac{"),
		f(function(_, snip)
			return snip.captures[1]
		end, {}),
		t("}{"),
		i(1),
		t("}"),
	}, { condition = tex.in_math }),

	s(
		{ trig = "//", name = "fraction", hidden = true },
		{ t("\\frac{"), i(1), t("}{"), i(2), t("}") },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "bin", name = "binomial coefficient", hidden = true },
		{ t("\\binom{"), i(1), t("}{"), i(2), t("}") },
		{ condition = tex.in_math }
	),

	s({ trig = "ses", name = "short exact sequence", hidden = true }, {
		c(1, { t("0"), t("1") }),
		t("\\longrightarrow "),
		i(2),
		t("\\longrightarrow "),
		i(3),
		t("\\longrightarrow "),
		i(4),
		t("\\longrightarrow "),
		rep(1),
		i(0),
	}, { condition = tex.in_math }),

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

local operator_snippet = function(context, opts)
	opts = opts or {}
	context.dscr = context.trig .. " with automatic backslash"
	context.name = context.trig
	context.docstring = [[\]] .. context.trig
	return s(context, t([[\]] .. context.trig), opts)
end

local operator_snippets = {}
for _, v in ipairs(operator_specs) do
	table.insert(operator_snippets, operator_snippet({ trig = v }, { condition = tex.in_math }))
end
vim.list_extend(autosnips, operator_snippets)

return nil, autosnips
