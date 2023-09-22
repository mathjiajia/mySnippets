local M = {}

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local extras = require("luasnip.extras")
local l = extras.lambda
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local env_opts = { condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }

local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
	-- Generating functions for Matrix/Cases - thanks L3MON4D3
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(nil, fmta([[<><><><>]], { t(user_arg1), t(capture), t(user_arg2), i(0) }))
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(nil, fmta([[<><><><>]], { t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }))
	end
end

M.get_visual = function(_, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else
		return sn(nil, i(1))
	end
end

M.postfix_snippet = function(context, command, opts)
	context.dscr = context.dscr
	context.name = context.dscr
	context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
	return postfix(context, { d(1, dynamic_postfix, {}, { user_args = { command.pre, command.post } }) }, opts)
end

M.symbol_snippet = function(context, command)
	context.dscr = command
	context.name = context.name or command:gsub([[\]], "")
	context.docstring = command .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(command), { opts = tex.in_math })
end

M.operator_snippet = function(context)
	context.name = context.trig
	context.dscr = context.trig .. " with automatic backslash"
	return s(context, t([[\]] .. context.trig), { condition = tex.in_math })
end

M.phrase_snippet = function(context, body)
	context.dscr = context.trig
	return s(context, t(body), { condition = tex.in_text, show_condition = tex.in_text })
end

M.single_command_snippet = function(context, command, opts, ext)
	opts = opts or {}
	context.dscr = context.dscr or command
	context.name = context.name or context.dscr
	local docstring, offset, cnode, lnode
	if ext.choice == true then
		docstring = "[" .. [[(<1>)?]] .. "]" .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
		offset = 1
		cnode = c(1, { t(""), sn(nil, { t("["), i(1, "opt"), t("]") }) })
	else
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
	end
	if ext.label == true then
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[\label{(]] .. ext.short .. [[:<2>)?}]] .. [[<0>]]
		ext.short = ext.short or command
		lnode = c(2 + (offset or 0), {
			t(""),
			sn(nil, fmta([[\label{<>:<>}]], { t(ext.short), i(1) })),
		})
	end
	context.docstring = context.docstring or (command .. docstring)
	-- stype = ext.stype or s
	return s(
		context,
		fmta(command .. [[<>{<>}<><>]], { cnode or t(""), i(1 + (offset or 0)), (lnode or t("")), i(0) }),
		opts
	)
end

M.env_snippet = function(context, env)
	context.name = context.trig
	context.dscr = context.trig .. " Environment"
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
		env_opts
	)
end

M.labeled_env_snippet = function(context, env)
	context.name = context.trig
	context.dscr = "Labeled" .. context.trig .. " Environment"
	context.trig = "l" .. context.trig
	return s(
		context,
		fmta(
			[[
			\begin{<>}[<>]\label{<>:<>}
				<>
			\end{<>}
			]],
			{ t(env), i(1), t(context.name), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1), i(0), t(env) }
		),
		env_opts
	)
end

M.sec_snippet = function(context, sec)
	context.name = sec
	context.dscr = sec
	return s(
		context,
		fmta(
			[[
			\<>{<>}\label{<>:<>}
			<>
			]],
			{ t(sec), i(1), t(context.trig), l(l._1:gsub("[^%w]+", "_"):gsub("_*$", ""):lower(), 1), i(0) }
		),
		{ condition = conds_expand.line_begin * tex.in_text, show_condition = pos.line_begin * tex.in_text }
	)
end

return M
