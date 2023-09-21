local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

-- local texpairs = {
-- 	{ "(", ")" },
-- 	{ "\\left(", "\\right)" },
-- 	{ "\\big(", "\\big)" },
-- 	{ "\\Big(", "\\Big)" },
-- 	{ "\\bigg(", "\\bigg)" },
-- 	{ "\\Bigg(", "\\Bigg)" },
-- }

-- local function choices_from_pairlist(ji, list)
-- 	local choices = {}
-- 	for _, pair in ipairs(list) do
-- 		table.insert(choices, {
-- 			t(pair[1]),
-- 			r(1, "inside_pairs", dl(1, l.LS_SELECT_DEDENT)),
-- 			t(pair[2]),
-- 		})
-- 	end
-- 	return c(ji, choices)
-- end

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

snips = {
	-- s(
	-- 	{ trig = "(", name = "parenthesis", dscr = "Different kinds of parenthesis" },
	-- 	{ choices_from_pairlist(1, texpairs) },
	-- 	{ condition = tex.in_text }
	-- ),

	s(
		{ trig = "lr(", name = "left( right)", hidden = true },
		{ t({ "\\left( " }), i(1), t({ "\\right)" }) },
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "lr|", name = "leftvert rightvert", hidden = true },
		{ t({ "\\left\\lvert " }), i(1), t({ "\\right\\lvert" }) },
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "lr{", name = "left\\{ right\\}", hidden = true },
		{ t({ "\\left\\{ " }), i(1), t({ "\\right\\}" }) },
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "lrb", name = "left\\{ right\\}", hidden = true },
		{ t({ "\\left\\{ " }), i(1), t({ "\\right\\}" }) },
		{ condition = tex.in_math, show_condition = tex.in_math }
	),
	s(
		{ trig = "lr[", name = "left[ right]", hidden = true },
		{ t({ "\\left[ " }), i(1), t({ "\\right]" }) },
		{ condition = tex.in_math, show_condition = tex.in_math }
	),

	s(
		{
			trig = "([bBpvV])mat_(%d+)x_(%d+)([ar])",
			name = "[bBpvV]matrix",
			dscr = "matrices",
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
		{ trig = "lra", name = "leftangle rightangle", hidden = true },
		{ t({ "\\langle " }), i(1), t({ "\\rangle" }) },
		{ condition = tex.in_math }
	),

	s({ trig = "cvec", name = "column vector", hidden = true }, {
		t({ "\\begin{pmatrix}", "\t" }),
		i(1, "x"),
		t("}_"),
		i(2, "1"),
		t({ "\\\\", "\\vdots \\\\", "" }),
		rep(1),
		t("_"),
		i(3, "n"),
		t({ "", "\\end{pmatrix}" }),
	}, { condition = tex.in_math }),
}

return snips, autosnips
