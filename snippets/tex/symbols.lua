local autosnips = {}

local tex = require("mySnippets.latex")

autosnips = {
	s({ trig = "\\varpii", name = "\\varpi_i", hidden = true }, { t("\\varpi_{i}") }, { condition = tex.in_math }),
	s({ trig = "\\varphii", name = "\\varphi_i", hidden = true }, { t("\\varphi_{i}") }, { condition = tex.in_math }),
	s(
		{ trig = "\\([xX])ii", name = "\\xi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%si_{i}", snip.captures[1])
		end, {}) },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "\\([pP])ii", name = "\\pi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%si_{i}", snip.captures[1])
		end, {}) },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "\\([pP])hii", name = "\\phi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%shi_{i}", snip.captures[1])
		end, {}) },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "\\([cC])hii", name = "\\chi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%shi_{i}", snip.captures[1])
		end, {}) },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "\\([pP])sii", name = "\\psi_{i}", regTrig = true, hidden = true },
		{ f(function(_, snip)
			return string.format("\\%ssi_{i}", snip.captures[1])
		end, {}) },
		{ condition = tex.in_math }
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
	}, { condition = tex.in_math }),

	s({
		trig = "(%a)(%d)",
		name = "auto subscript 1",
		dscr = "Subscript with a single number.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_%s", snip.captures[1], snip.captures[2])
		end, {}),
	}, { condition = tex.in_math }),

	s({
		trig = "(%a)_(%d%d)",
		name = "auto subscript 2",
		dscr = "Subscript with two numbers.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
		end, {}),
	}, { condition = tex.in_math }),

	s(
		{ trig = "^-", name = "negative exponents", wordTrig = false, hidden = true },
		fmta([[^{-<>}]], i(1)),
		{ condition = tex.in_math }
	),
	s({ trig = "sq", name = "square root", hidden = true }, fmta([[\\sqrt{<>}]], i(1)), { condition = tex.in_math }),
	s(
		{ trig = "__", name = "subscript", wordTrig = false, hidden = true },
		fmta([[_{<>}]], i(1)),
		{ condition = tex.in_math }
	),
	s(
		{ trig = "^^", name = "supscript", wordTrig = false, hidden = true },
		fmta([[^{<>}]], i(1)),
		{ condition = tex.in_math }
	),
	s(
		{ trig = "rup", name = "round up", wordTrig = false, hidden = true },
		fmta([[\rup{<>}]], i(1)),
		{ condition = tex.in_math }
	),
	s(
		{ trig = "rwn", name = "round down", wordTrig = false, hidden = true },
		fmta([[\rdown{<>}]], i(1)),
		{ condition = tex.in_math }
	),

	s(
		{ trig = "srt", name = "square root", wordTrig = false, hidden = true },
		fmta([[\sqrt{<>}]], i(1)),
		{ condition = tex.in_math }
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
	-- s(
	-- 	{ trig = '<|', name = 'triangleleft <|', wordTrig = false, hidden = true },
	-- 	{ t('\\triangleleft ') },
	-- 	{ condition = tex.in_math }
	-- ),
	-- s(
	-- 	{ trig = '|>', name = 'triangleright |>', wordTrig = false, hidden = true },
	-- 	{ t('\\triangleright ') },
	-- 	{ condition = tex.in_math }
	-- ),

	s(
		{ trig = "MK", name = "Mori-Kleiman cone", hidden = true },
		{ t("\\cNE("), i(1), t(")") },
		{ condition = tex.in_math }
	),
	s(
		{ trig = "([QRZ])P", name = "positive", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{>0}"
		end, {}) },
		{ condition = tex.in_math }
	),

	s(
		{ trig = "([QRZ])N", name = "negative", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{<0}"
		end, {}) },
		{ condition = tex.in_math }
	),

	s(
		{ trig = "([qr])le", name = "linearly equivalent", wordTrig = false, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\sim_{\\mathbb{" .. string.upper(snip.captures[1]) .. "}} "
		end, {}) },
		{ condition = tex.in_math }
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
	}, { condition = tex.in_math }),
	s({ trig = "(%a)jj", name = "alph j", wordTrig = false, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{j}"
		end, {}),
	}, { condition = tex.in_math }),
}

local symbol_specs = {
	-- logic
	inn = { context = { name = "∈" }, command = [[\in]] },
	["!in"] = { context = { name = "∉" }, command = [[\not\in]] },
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
	[";="] = { context = { name = "≡" }, command = [[\equiv]] },
	[";-"] = { context = { name = "\\" }, command = [[\setminus]] },
	[";A"] = { context = { name = "∀" }, command = [[\forall]] },
	[";E"] = { context = { name = "∃" }, command = [[\exists]] },
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

local symbol_snippet = function(context, command)
	context.dscr = command
	context.name = context.name or command:gsub([[\]], "")
	context.docstring = command .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(command), { condition = tex.in_math })
end

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
	table.insert(symbol_snippets, symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command))
end
vim.list_extend(autosnips, symbol_snippets)

return nil, autosnips
