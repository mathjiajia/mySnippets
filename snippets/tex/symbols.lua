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
		command = [[\text]],
	},
	sbf = {
		context = { name = "symbf", desc = "bold math text" },
		command = [[\symbf]],
	},
	syi = {
		context = { name = "symit", desc = "italic math text" },
		command = [[\symit]],
	},
	udd = {
		context = { name = "underline (math)", desc = "underlined text in math mode" },
		command = [[\underline]],
	},
	conj = {
		context = { name = "conjugate", desc = "conjugate (overline)" },
		command = [[\overline]],
	},
	rup = {
		context = { name = "round up", desc = "auto round up", wordTrig = false },
		command = [[\rup]],
	},
	["rdn"] = {
		context = { name = "round down", desc = "auto round down", wordTrig = false },
		command = [[\rdown]],
	},
	["__"] = {
		context = { name = "subscript", desc = "auto subscript", wordTrig = false },
		command = [[_]],
	},
	["^^"] = {
		context = { name = "superscript", desc = "auto superscript", wordTrig = false },
		command = [[^]],
	},
	sbt = {
		context = { name = "substack", desc = "substack for sums/products" },
		command = [[\substack]],
	},
	sq = {
		context = { name = "sqrt", desc = "sqrt" },
		command = [[\sqrt]],
		ext = { choice = true },
	},
}

local symbol_specs = {
	-- logic
	inn = { context = { name = "∈" }, command = [[\in]] },
	["!in"] = { context = { name = "∉" }, command = [[\not\in]] },
	[";A"] = { context = { name = "∀" }, command = [[\forall]] },
	[";E"] = { context = { name = "∃" }, command = [[\exists]] },
	-- operators
	["!="] = { context = { name = "!=" }, command = [[\neq]] },
	["<="] = { context = { name = "≤" }, command = [[\leq]] },
	[">="] = { context = { name = "≥" }, command = [[\geq]] },
	["<<"] = { context = { name = "<<" }, command = [[\ll]] },
	[">>"] = { context = { name = ">>" }, command = [[\gg]] },
	["~~"] = { context = { name = "~" }, command = [[\sim]] },
	["~="] = { context = { name = "≃" }, command = [[\simeq]] },
	["=~"] = { context = { name = "≅" }, command = [[\cong]] },
	["::"] = { context = { name = ":" }, command = [[\colon ]] },
	[":="] = { context = { name = "≔" }, command = [[\coloneqq ]] },
	["**"] = { context = { name = "*" }, command = [[^{*}]] },
	["..."] = { context = { name = "·" }, command = [[\dots]] },
	["||"] = { context = { name = "|" }, command = [[\mid ]] },
	xx = { context = { name = "×" }, command = [[\times]] },
	["o+"] = { context = { name = "⊕" }, command = [[\oplus ]] },
	ox = { context = { name = "⊗" }, command = [[\otimes]] },
	nvs = { context = { name = "-1" }, command = [[^{-1}]] },
	nabl = { context = { name = "∇" }, command = [[\\nabla]] },
	[";="] = { context = { name = "≡" }, command = [[\equiv]] },
	[";-"] = { context = { name = "\\" }, command = [[\setminus]] },
	-- sets
	AA = { context = { name = "𝔸" }, command = [[\mathbb{A}]] },
	CC = { context = { name = "ℂ" }, command = [[\mathbb{C}]] },
	DD = { context = { name = "𝔻" }, command = [[\mathbb{D}]] },
	FF = { context = { name = "𝔽" }, command = [[\mathbb{F}]] },
	GG = { context = { name = "𝔾" }, command = [[\mathbb{G}]] },
	HH = { context = { name = "ℍ" }, command = [[\mathbb{H}]] },
	NN = { context = { name = "ℕ" }, command = [[\mathbb{N}]] },
	OO = { context = { name = "O" }, command = [[\mathcal{O}]] },
	PP = { context = { name = "ℙ" }, command = [[\mathbb{P}]] },
	QQ = { context = { name = "ℚ" }, command = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, command = [[\mathbb{R}]] },
	ZZ = { context = { name = "ℤ" }, command = [[\mathbb{Z}]] },
	cc = { context = { name = "⊂" }, command = [[\subset]] },
	cq = { context = { name = "⊆" }, command = [[\subseteq]] },
	qq = { context = { name = "⊃" }, command = [[\supset]] },
	qc = { context = { name = "⊇" }, command = [[\supseteq]] },
	Nn = { context = { name = "∩" }, command = [[\cap ]] },
	UU = { context = { name = "∪" }, command = [[\cup]] },
	-- arrows
	["=>"] = { context = { name = "⇒" }, command = [[\implies]] },
	["=<"] = { context = { name = "⇐" }, command = [[\impliedby]] },
	["->"] = { context = { name = "→", priority = 250 }, command = [[\to]] },
	["!>"] = { context = { name = "↦" }, command = [[\mapsto]] },
	["-->"] = { context = { name = "⟶", priority = 500 }, command = [[\longrightarrow]] },
	["<->"] = { context = { name = "↔", priority = 500 }, command = [[\leftrightarrow]] },
	["2>"] = { context = { name = "⇉", priority = 400 }, command = [[\rightrightarrows]] },
	iff = { context = { name = "⟺" }, command = [[\iff]] },
	upar = { context = { name = "↑" }, command = [[\uparrow]] },
	dnar = { context = { name = "↓" }, command = [[\downarrow]] },
	-- etc
	dag = { context = { name = "†" }, command = [[\dagger]] },
	lll = { context = { name = "ℓ" }, command = [[\ell]] },
	quad = { context = { name = " " }, command = [[\quad ]] },
	-- xmm = { context = { name = "x_m" }, command = [[x_{m}]] },
	-- xnn = { context = { name = "x_n" }, command = [[x_{n}]] },
	-- ymm = { context = { name = "y_m" }, command = [[y_{m}]] },
	-- ynn = { context = { name = "y_n" }, command = [[y_{n}]] },
}

local symbol_snippets = {}

for k, v in pairs(single_command_math_specs) do
	table.insert(
		symbol_snippets,
		single_command_snippet(
			vim.tbl_deep_extend("keep", { trig = k }, v.context),
			v.command,
			{ condition = tex.in_math },
			v.ext or {}
		)
	)
end

for k, v in pairs(symbol_specs) do
	table.insert(symbol_snippets, symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command))
end
vim.list_extend(autosnips, symbol_snippets)

return nil, autosnips
