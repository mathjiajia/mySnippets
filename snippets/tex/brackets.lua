local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

local brackets = {
	a = { "\\langle", "\\rangle" },
	A = { "Angle", "Angle" },
	b = { "brack", "brack" },
	B = { "Brack", "Brack" },
	c = { "brace", "brace" },
	m = { "|", "|" },
	p = { "(", ")" },
}

local get_visual = function(_, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

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
		{ trig = "lr([aAbBcmp])", name = "left right", dscr = "left right delimiters", regTrig = true, hidden = true },
		fmta([[\left<> <>\right<><>]], {
			f(function(_, snip)
				local cap = snip.captures[1] or "p"
				return brackets[cap][1]
			end),
			d(1, get_visual),
			f(function(_, snip)
				local cap = snip.captures[1] or "p"
				return brackets[cap][2]
			end),
			i(0),
		}),
		{ condition = tex.in_math, show_condition = tex.in_math }
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
