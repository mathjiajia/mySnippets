local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local opts = {
	condition = conds_expand.line_begin * pos.in_beamer * tex.in_text,
	show_condition = pos.line_begin * pos.in_beamer * tex.in_text,
}

autosnips = {
	s(
		{ trig = "bfr", name = "Beamer Frame Environment" },
		fmta(
			[[
			\begin{frame}
				\frametitle{<>}
				<>
			\end{frame}
			]],
			{ i(1, "frame title"), i(0) }
		),
		opts
	),

	s(
		{ trig = "bbl", name = "Beamer Block Environment" },
		fmta(
			[[
			\begin{block}{<>}
				<>
			\\end{block}
			]],
			{ i(1), i(0) }
		),
		opts
	),
}

return nil, autosnips
