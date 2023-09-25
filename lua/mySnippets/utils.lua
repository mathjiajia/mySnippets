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

-- Dynamically generates snippets based on matched postfix.
local function dynamic_postfix(_, parent, _, arg1, arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(nil, fmta([[<><><><>]], { t(arg1), t(capture), t(arg2), i(0) }))
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(nil, fmta([[<><><><>]], { t(arg1), i(1, visual_placeholder), t(arg2), i(0) }))
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
	context.name = context.desc
	context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
	return postfix(context, { d(1, dynamic_postfix, {}, { user_args = { command.pre, command.post } }) }, opts)
end

M.symbol_snippet = function(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(cmd))
end

M.sequence_snippet = function(trig, cmd, desc)
	local context = {
		trig = trig,
		name = desc,
		desc = desc,
		condition = tex.in_math,
		show_condition = tex.in_math,
	}
	return s(
		context,
		fmta([[\<><> <>"]], { t(cmd), c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) })
	)
end

M.operator_snippet = function(trig)
	local context = {
		trig = trig,
		name = trig,
		condition = tex.in_math,
		show_condition = tex.in_math,
	}
	return s(context, t([[\]] .. trig))
end

M.phrase_snippet = function(trig, body)
	local context = {
		trig = trig,
		desc = trig,
		condition = tex.in_text,
		show_condition = tex.in_text,
	}
	return s(context, t(body))
end

M.single_command_snippet = function(context, cmd, ext)
	context.desc = context.desc or cmd
	context.name = context.name or context.desc
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
		ext.short = ext.short or cmd
		lnode = c(2 + (offset or 0), {
			t(""),
			sn(nil, fmta([[\label{<>:<>}]], { t(ext.short), i(1) })),
		})
	end
	context.docstring = context.docstring or (cmd .. docstring)
	-- stype = ext.stype or s
	return s(context, fmta(cmd .. [[<>{<>}<><>]], { cnode or t(""), i(1 + (offset or 0)), (lnode or t("")), i(0) }))
end

M.env_snippet = function(trig, env)
	local context = {
		trig = trig,
		name = trig,
		desc = trig .. " Environment",
	}
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

M.labeled_env_snippet = function(trig, env)
	local context = {
		trig = "l" .. trig,
		name = trig,
		desc = "Labeled" .. trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\begin{<>}[<>]\label{<>:<>}
				<>
			\end{<>}
			]],
			{ t(env), i(1), t(trig), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1), i(0), t(env) }
		),
		env_opts
	)
end

return M
