local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local rec_ls
rec_ls = function()
	return sn(nil, {
		c(1, {
			t({ "" }),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		}),
	})
end

local generate_cases = function(_, snip)
	local rows = tonumber(snip.captures[1]) or 2
	local cols = 2
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end

	table.remove(nodes, #nodes)
	return sn(nil, nodes)
end

autosnips = {
	s(
		{ trig = "beg", name = "begin/end", dscr = "begin/end environment (generic)" },
		{ t({ "\\begin{" }), i(1), t({ "}", "\t" }), i(0), t({ "", "\\end{" }), rep(1), t({ "}" }) },
		{ condition = conds_expand.line_begin, show_condition = pos.line_begin }
	),

	s(
		{ trig = "lprf", name = "Titled Proof", dscr = "Create a titled proof environment." },
		{ t("\\begin{proof}[Proof of \\cref{"), i(1), t({ "}]", "\t" }), i(0), t({ "", "\\end{proof}" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }
	),

	s({ trig = "lthm", name = "labled Theorem Environment", dscr = "Create a labled theorem environment." }, {
		t({ "\\begin{theorem}[" }),
		i(1),
		t({ "]\\label{thm:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{theorem}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "llem", name = "labled Lemma Environment", dscr = "Create a labled lemma environment." }, {
		t({ "\\begin{lemma}[" }),
		i(1),
		t({ "]\\label{lem:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{lemma}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "ldef", name = "labled Definition Environment", dscr = "Create a labled definition environment." }, {
		t({ "\\begin{definition}[" }),
		i(1),
		t({ "]\\label{def:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{definition}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "lprop", name = "labled Proposition Environment", dscr = "Create a labled proposition environment." }, {
		t({ "\\begin{proposition}[" }),
		i(1),
		t({ "]\\label{prop:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{proposition}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "lcor", name = "labled Corollary Environment", dscr = "Create a labled corollary environment." }, {
		t({ "\\begin{corollary}[" }),
		i(1),
		t({ "]\\label{cor:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{corollary}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "lrem", name = "labled Remark Environment", dscr = "labled Create a remark environment." }, {
		t({ "\\begin{remark}[" }),
		i(1),
		t({ "]\\label{rem:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{remark}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),

	s({ trig = "lconj", name = "labled Conjecture Environment", dscr = "Create a labled conjecture environment." }, {
		t({ "\\begin{conjecture}[" }),
		i(1),
		t({ "]\\label{conj:" }),
		l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{conjecture}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }),

	s(
		{ trig = "(%d?)cases", name = "cases", dscr = "cases", regTrig = true, hidden = true },
		fmta(
			[[
			\begin{cases}
				<>
			.\end{cases}
			]],
			{ d(1, generate_cases) }
		),
		{ condition = conds_expand.line_begin * tex.in_math, show_condition = tex.in_math }
	),

	s(
		{ trig = "xym", name = "xymatrix Environment", dscr = "Create a xymatrix environment." },
		{ t({ "\\[", "\t\\xymatrix{", "\t\t" }), i(1), t({ " \\\\", "\t}", "\\]" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "bal", name = "Align Environment", dscr = "Create an align environment" },
		{ t({ "\\begin{align}", "\t" }), i(1), t({ "", "\\end{align}" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "bsal", name = "Align without a number", dscr = "Create an align environment without number" },
		{ t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "bit", name = "itemize", dscr = "bullet points (itemize)" },
		{ t({ "\\begin{itemize}", "\t\\item " }), i(1), d(2, rec_ls, {}), t({ "", "\\end{itemize}" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }
	),
	s(
		{ trig = "ben", name = "enumerate", dscr = "numbered list (enumerate)" },
		{ t({ "\\begin{enumerate}", "\t\\item " }), i(1), d(2, rec_ls, {}), t({ "", "\\end{enumerate}" }) },
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }
	),

	s({ trig = "lben", name = "labeled enumerate", dscr = "numbered list (enumerate)" }, {
		t({ "\\begin{enumerate}[label=(\\" }),
		c(1, {
			t("alph"),
			t("roman"),
			t("arabic"),
		}),
		t({ "*)]", "\t\\item " }),
		i(2),
		d(3, rec_ls, {}),
		t({ "", "\\end{enumerate}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = tex.in_text }),

	s({ trig = "bfu", name = "function" }, {
		t({ "\\begin{equation*}", "\t" }),
		i(1),
		t("\\colon "),
		i(2),
		t("\\longrightarrow "),
		i(3),
		t(", \\quad "),
		i(4),
		t("\\longmapsto "),
		rep(1),
		t("("),
		rep(4),
		t(") = "),
		i(0),
		t({ "", "\\end{equation*}" }),
	}, { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }),
}

local env_specs = {
	beq = "equation",
	bseq = "equation*",
	proof = "proof",
	thm = "theorem",
	lem = "lemma",
	def = "definition",
	prop = "equation",
	cor = "corollary",
	rem = "remark",
	conj = "conjecture",
}

local env_snippet = function(context, env, opts)
	context.name = context.trig
	context.dscr = context.trig .. " with automatic backslash"
	context.docstring = [[\]] .. context.trig
	return s(
		context,
		fmta(
			[[
			\begin{<>}
				<>
			\end{<>}
			]],
			{ t(env), i(0), t(env) }
		),
		opts
	)
end

local env_snippets = {}
for k, v in pairs(env_specs) do
	table.insert(
		env_snippets,
		env_snippet(
			{ trig = k },
			v,
			{ condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }
		)
	)
end
vim.list_extend(autosnips, env_snippets)

return nil, autosnips
