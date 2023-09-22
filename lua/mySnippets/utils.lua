local M = {}

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
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

M.postfix_snippet = function(context, command, opts)
	context.dscr = context.dscr
	context.name = context.dscr
	context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
	return postfix(context, { d(1, dynamic_postfix, {}, { user_args = { command.pre, command.post } }) }, opts)
end

M.symbol_snippet = function(context, command, opts)
	context.dscr = command
	context.name = context.name or command:gsub([[\]], "")
	context.docstring = command .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(command), opts)
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

return M
