local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")
local env_snippet = require("mySnippets.utils").env_snippet
local labeled_env_snippet = require("mySnippets.utils").labeled_env_snippet

local opts = { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }

-- Generating functions for Matrix/Cases
local generate_matrix = function(_, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
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
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- update for cases
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

snips = {
	s(
		{
			trig = "([bBpvV])mat_(%d+)x_(%d+)([ar])",
			name = "[bBpvV]matrix",
			desc = "matrices",
			regTrig = true,
			hidden = true,
		},
		fmta(
			[[
			\begin{<>}<>
				<>
			\end{<>}
			]],
			{
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
				f(function(_, snip)
					if snip.captures[4] == "a" then
						local out = string.rep("c", tonumber(snip.captures[3]) - 1)
						return "[" .. out .. "|c]"
					end
					return ""
				end),
				d(1, generate_matrix),
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
			}
		),
		{ condition = tex.in_math }
	),
}

autosnips = {
	s(
		{ trig = "beg", name = "begin/end", desc = "begin/end environment (generic)" },
		{ t({ "\\begin{" }), i(1), t({ "}", "\t" }), i(0), t({ "", "\\end{" }), rep(1), t({ "}" }) },
		fmta(
			[[
			\begin{<>}
				<>
			\end{<>}
			]],
			{ i(1), i(0), rep(1) }
		),
		{ condition = conds_expand.line_begin, show_condition = pos.line_begin }
	),
	s(
		{ trig = "lprf", name = "Titled Proof", desc = "Create a titled proof environment." },
		fmta(
			[[
			\begin{proof}[Proof of \cref{<>}]
				<>
			\end{proof}
			]],
			{ i(1), i(0) }
		),
		opts
	),

	s(
		{ trig = "(%d?)cases", name = "cases", desc = "cases", regTrig = true, hidden = true },
		fmta(
			[[
			\begin{cases}
				<>
			\end{cases}
			]],
			{ d(1, generate_cases) }
		),
		opts
	),

	s(
		{ trig = "xym", name = "xymatrix Environment", desc = "Create a xymatrix environment." },
		fmta(
			[[
			\[
				\xymatrix{
					<> \\
				}
			\]
			]],
			{ i(1) }
		),
		opts
	),
	s(
		{ trig = "bit", name = "itemize", desc = "bullet points (itemize)" },
		fmta(
			[[
			\begin{itemize}
				\item <>
			\end{itemize}
			]],
			{ c(1, { i(0), sn(nil, fmta([[[<>] <>]], { i(1), i(0) })) }) }
		),
		opts
	),
	s(
		{ trig = "ben", name = "enumerate", desc = "numbered list (enumerate)" },
		fmta(
			[[
			\begin{enumerate}<>
				\item <>
			\end{enumerate}
			]],
			{
				c(1, { t(""), sn(nil, fmta([[[label=<>] ]], { c(1, { t("(\\alph*)"), t("(\\roman*)"), i(1) }) })) }),
				c(2, { i(0), sn(nil, fmta([[[<>] <>]], { i(1), i(0) })) }),
			}
		),
		opts
	),

	-- generate new bullet points
	s(
		{ trig = "--", hidden = true },
		{ t("\\item ") },
		{ condition = conds_expand.line_begin * tex.in_bullets, show_condition = pos.line_begin * tex.in_bullets }
	),
	s(
		{ trig = "!-", name = "bullet point", desc = "bullet point with custom text" },
		fmta([[\item [<>]<>]], { i(1), i(0) }),
		{ condition = conds_expand.line_begin * tex.in_bullets, show_condition = pos.line_begin * tex.in_bullets }
	),

	s(
		{ trig = "bal", name = "align(|*|ed)", desc = "align math" },
		fmta(
			[[
			\begin{align<>}
				<>
			\end{align<>}
			]],
			{ c(1, { t("*"), t(""), t("ed") }), i(2), rep(1) }
		),
		{ condition = conds_expand.line_begin, show_condition = pos.line_begin }
	),

	s({ trig = "bfu", name = "function" }, {
		fmta(
			[[
			\\begin{equation*}
				<>\colon <>\longrightarrow <>, \quad <>\longmapsto <>(<>)=<>
			\end{equation*}
			]],
			{ i(1), i(2), i(3), i(4), rep(1), rep(4), i(0) }
		),
	}, opts),
}

local env_specs = {
	beq = "equation",
	bseq = "equation*",
	proof = "proof",
}
local labeled_env_specs = {
	thm = "theorem",
	lem = "lemma",
	def = "definition",
	prop = "proposition",
	cor = "corollary",
	rem = "remark",
	conj = "conjecture",
}
env_specs = vim.tbl_extend("keep", env_specs, labeled_env_specs)

local env_snippets = {}

for k, v in pairs(env_specs) do
	table.insert(env_snippets, env_snippet({ trig = k }, v))
end
for k, v in pairs(labeled_env_specs) do
	table.insert(env_snippets, labeled_env_snippet({ trig = k }, v))
end

vim.list_extend(autosnips, env_snippets)

return snips, autosnips
