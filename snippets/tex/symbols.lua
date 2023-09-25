local autosnips = {}

local tex = require("mySnippets.latex")
local symbol_snippet = require("mySnippets.utils").symbol_snippet
local single_command_snippet = require("mySnippets.utils").single_command_snippet

local opts = { condition = tex.in_math }

autosnips = {
	s({ trig = "rmap", name = "rational map arrow", wordTrig = false, hidden = true }, {
		d(1, function()
			if tex.in_xymatrix() then
				return sn(nil, { t({ "\\ar@{-->}[" }), i(1), t({ "]" }) })
			else
				return sn(nil, { t("\\dashrightarrow ") })
			end
		end),
	}, opts),

	s({ trig = "emb", name = "embeddeing map arrow", wordTrig = false, hidden = true }, {
		d(1, function()
			if tex.in_xymatrix() then
				return sn(nil, { t({ "\\ar@{^{(}->}[" }), i(1), t({ "]" }) })
			else
				return sn(nil, { t("\\hookrightarrow ") })
			end
		end),
	}, opts),

	s({ trig = "\\varpii", name = "\\varpi_i", hidden = true }, { t("\\varpi_{i}") }, opts),
	s({ trig = "\\varphii", name = "\\varphi_i", hidden = true }, { t("\\varphi_{i}") }, opts),
	s(
		{ trig = "\\([xX])ii", name = "\\xi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%si_{i}", snip.captures[1])
		end, {}) },
		opts
	),
	s(
		{ trig = "\\([pP])ii", name = "\\pi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%si_{i}", snip.captures[1])
		end, {}) },
		opts
	),
	s(
		{ trig = "\\([pP])hii", name = "\\phi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%shi_{i}", snip.captures[1])
		end, {}) },
		opts
	),
	s(
		{ trig = "\\([cC])hii", name = "\\chi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%shi_{i}", snip.captures[1])
		end, {}) },
		opts
	),
	s(
		{ trig = "\\([pP])sii", name = "\\psi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%ssi_{i}", snip.captures[1])
		end, {}) },
		opts
	),

	s({
		trig = "O([A-NP-Za-z])",
		name = "local ring, structure sheaf",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return "\\mathcal{O}_{" .. snip.captures[1] .. "}"
		end, {}),
	}, opts),

	s({
		trig = "(%a)(%d)",
		name = "auto subscript 1",
		desc = "Subscript with a single number.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_%s", snip.captures[1], snip.captures[2])
		end, {}),
	}, opts),

	s({
		trig = "(%a)_(%d%d)",
		name = "auto subscript 2",
		desc = "Subscript with two numbers.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
		end, {}),
	}, opts),

	s({ trig = "^-", name = "negative exponents", wordTrig = false, hidden = true }, fmta([[^{-<>}]], { i(1) }), opts),
	s(
		{ trig = "set", name = "set", desc = "set" },
		fmta([[\{<>\}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "nnn", name = "bigcap", desc = "bigcap" },
		fmta([[\bigcap<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),

	s(
		{ trig = "uuu", name = "bigcup", desc = "bigcup" },
		fmta([[\bigcup<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	-- s(
	-- 	{ trig = "<|", name = "triangleleft <|", wordTrig = false, hidden = true },
	-- 	{ t("\\triangleleft ") },
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "|>", name = "triangleright |>", wordTrig = false, hidden = true },
	-- 	{ t("\\triangleright ") },
	-- 	opts
	-- ),

	s({ trig = "MK", name = "Mori-Kleiman cone", hidden = true }, { t("\\cNE("), i(1), t(")") }, opts),
	s(
		{ trig = "([QRZ])P", name = "positive", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{>0}"
		end, {}) },
		opts
	),

	s(
		{ trig = "([QRZ])N", name = "negative", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{<0}"
		end, {}) },
		opts
	),

	s(
		{ trig = "([qr])le", name = "linearly equivalent", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\sim_{\\mathbb{" .. string.upper(snip.captures[1]) .. "}} "
		end, {}) },
		opts
	),

	s(
		{ trig = "==", name = "align equls", wordTrig = false, hidden = true },
		{ t("& = ") },
		{ condition = tex.in_align }
	),
	s(
		{ trig = "ar", name = "normal arrows", hidden = true },
		{ t("\\ar["), i(1), t("]") },
		{ condition = tex.in_xymatrix }
	),

	s({ trig = "(%a)ii", name = "alph i", wordTrig = false, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{i}"
		end, {}),
	}, opts),
	s({ trig = "(%a)jj", name = "alph j", wordTrig = false, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{j}"
		end, {}),
	}, opts),
}

local single_command_math_specs = {
	tt = {
		context = { name = "text (math)", desc = "text in math mode" },
		cmd = [[\text]],
	},
	sbf = {
		context = { name = "symbf", desc = "bold math text" },
		cmd = [[\symbf]],
	},
	syi = {
		context = { name = "symit", desc = "italic math text" },
		cmd = [[\symit]],
	},
	udd = {
		context = { name = "underline (math)", desc = "underlined text in math mode" },
		cmd = [[\underline]],
	},
	conj = {
		context = { name = "conjugate", desc = "conjugate (overline)" },
		cmd = [[\overline]],
	},
	rup = {
		context = { name = "round up", desc = "auto round up", wordTrig = false },
		cmd = [[\rup]],
	},
	["rdn"] = {
		context = { name = "round down", desc = "auto round down", wordTrig = false },
		cmd = [[\rdown]],
	},
	["__"] = {
		context = { name = "subscript", desc = "auto subscript", wordTrig = false },
		cmd = [[_]],
	},
	["^^"] = {
		context = { name = "superscript", desc = "auto superscript", wordTrig = false },
		cmd = [[^]],
	},
	hat = {
		context = { name = "hat", desc = "wide hat" },
		cmd = [[\widehat]],
	},
	bar = {
		context = { name = "overline", desc = "overline" },
		cmd = [[\overline]],
	},
	td = {
		context = { name = "tilde", desc = "wide tilde" },
		cmd = [[\widetilde]],
	},
	sbt = {
		context = { name = "substack", desc = "substack for sums/products" },
		cmd = [[\substack]],
	},
	sq = {
		context = { name = "sqrt", desc = "sqrt" },
		cmd = [[\sqrt]],
		ext = { choice = true },
	},
}

local symbol_specs = {
	-- logic
	inn = { context = { name = "∈" }, cmd = [[\in]] },
	["!in"] = { context = { name = "∉" }, cmd = [[\not\in]] },
	[";A"] = { context = { name = "∀" }, cmd = [[\forall]] },
	[";E"] = { context = { name = "∃" }, cmd = [[\exists]] },
	-- operators
	["!="] = { context = { name = "!=" }, cmd = [[\neq]] },
	["<="] = { context = { name = "≤" }, cmd = [[\leq]] },
	[">="] = { context = { name = "≥" }, cmd = [[\geq]] },
	["<<"] = { context = { name = "<<" }, cmd = [[\ll]] },
	[">>"] = { context = { name = ">>" }, cmd = [[\gg]] },
	["~~"] = { context = { name = "~" }, cmd = [[\sim]] },
	["~="] = { context = { name = "≃" }, cmd = [[\simeq]] },
	["=~"] = { context = { name = "≅" }, cmd = [[\cong]] },
	["::"] = { context = { name = ":" }, cmd = [[\colon ]] },
	[":="] = { context = { name = "≔" }, cmd = [[\coloneqq ]] },
	["**"] = { context = { name = "*" }, cmd = [[^{*}]] },
	["..."] = { context = { name = "·" }, cmd = [[\dots]] },
	["||"] = { context = { name = "|" }, cmd = [[\mid ]] },
	xx = { context = { name = "×" }, cmd = [[\times]] },
	["o+"] = { context = { name = "⊕" }, cmd = [[\oplus ]] },
	ox = { context = { name = "⊗" }, cmd = [[\otimes]] },
	nvs = { context = { name = "-1" }, cmd = [[^{-1}]] },
	nabl = { context = { name = "∇" }, cmd = [[\\nabla]] },
	[";="] = { context = { name = "≡" }, cmd = [[\equiv ]] },
	[";-"] = { context = { name = "\\" }, cmd = [[\setminus ]] },
	-- sets
	AA = { context = { name = "𝔸" }, cmd = [[\mathbb{A}]] },
	CC = { context = { name = "ℂ" }, cmd = [[\mathbb{C}]] },
	DD = { context = { name = "𝔻" }, cmd = [[\mathbb{D}]] },
	FF = { context = { name = "𝔽" }, cmd = [[\mathbb{F}]] },
	GG = { context = { name = "𝔾" }, cmd = [[\mathbb{G}]] },
	HH = { context = { name = "ℍ" }, cmd = [[\mathbb{H}]] },
	NN = { context = { name = "ℕ" }, cmd = [[\mathbb{N}]] },
	OO = { context = { name = "O" }, cmd = [[\mathcal{O}]] },
	PP = { context = { name = "ℙ" }, cmd = [[\mathbb{P}]] },
	QQ = { context = { name = "ℚ" }, cmd = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, cmd = [[\mathbb{R}]] },
	ZZ = { context = { name = "ℤ" }, cmd = [[\mathbb{Z}]] },
	cc = { context = { name = "⊂" }, cmd = [[\subset ]] },
	cq = { context = { name = "⊆" }, cmd = [[\subseteq ]] },
	qq = { context = { name = "⊃" }, cmd = [[\supset ]] },
	qc = { context = { name = "⊇" }, cmd = [[\supseteq ]] },
	Nn = { context = { name = "∩" }, cmd = [[\cap ]] },
	UU = { context = { name = "∪" }, cmd = [[\cup]] },
	-- arrows
	["=>"] = { context = { name = "⇒" }, cmd = [[\implies]] },
	["=<"] = { context = { name = "⇐" }, cmd = [[\impliedby]] },
	["->"] = { context = { name = "→", priority = 250 }, cmd = [[\to ]] },
	["!>"] = { context = { name = "↦" }, cmd = [[\mapsto ]] },
	["-->"] = { context = { name = "⟶", priority = 500 }, cmd = [[\longrightarrow ]] },
	["<->"] = { context = { name = "↔", priority = 500 }, cmd = [[\leftrightarrow ]] },
	["2>"] = { context = { name = "⇉", priority = 400 }, cmd = [[\rightrightarrows ]] },
	iff = { context = { name = "⟺" }, cmd = [[\iff ]] },
	upar = { context = { name = "↑" }, cmd = [[\uparrow]] },
	dnar = { context = { name = "↓" }, cmd = [[\downarrow]] },
	-- etc
	dag = { context = { name = "†" }, cmd = [[\dagger]] },
	lll = { context = { name = "ℓ" }, cmd = [[\ell]] },
	quad = { context = { name = " " }, cmd = [[\quad ]] },
	-- xmm = { context = { name = "x_m" }, cmd = [[x_{m}]] },
	-- xnn = { context = { name = "x_n" }, cmd = [[x_{n}]] },
	-- ymm = { context = { name = "y_m" }, cmd = [[y_{m}]] },
	-- ynn = { context = { name = "y_n" }, cmd = [[y_{n}]] },
}

local symbol_snippets = {}

for k, v in pairs(single_command_math_specs) do
	table.insert(
		symbol_snippets,
		single_command_snippet(
			vim.tbl_deep_extend("keep", { trig = k, condition = tex.in_math }, v.context),
			v.cmd,
			v.ext or {}
		)
	)
end

for k, v in pairs(symbol_specs) do
	table.insert(
		symbol_snippets,
		symbol_snippet(vim.tbl_deep_extend("keep", { trig = k, condition = tex.in_math }, v.context), v.cmd)
	)
end
vim.list_extend(autosnips, symbol_snippets)

return nil, autosnips
