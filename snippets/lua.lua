local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin }

local LUA_MODULE_RETURN_TS_QUERY = [[
(return_statement
	(expression_list
		(identifier) @return-value-name))
]]

local function get_returned_mod_name()
	local query = vim.treesitter.query.parse("lua", LUA_MODULE_RETURN_TS_QUERY)
	local parser = vim.treesitter.get_parser(0, "lua")
	local tree = parser:parse()[1]
	local num_lines = #vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, node, _ in query:iter_captures(tree:root(), 0, num_lines - 3, num_lines) do
		return vim.treesitter.get_node_text(node, 0, {})
	end
end

local function get_req_module(req_path)
	local parts = vim.split(req_path[1][1], "%.", { trimempty = true })
	return parts[#parts] or ""
end

local function get_req_module_upper(req_path)
	local path = get_req_module(req_path)
	return path:sub(1, 1):upper() .. path:sub(2)
end

snips = {
	s(
		"req",
		fmt("local {} = require('{}')", {
			c(2, {
				f(get_req_module, { 1 }),
				f(get_req_module_upper, { 1 }),
			}),
			i(1),
		}),
		opts
	),

	s(
		"mfn",
		c(1, {
			fmt("function {}.{}({})\n  {}\nend", {
				f(get_returned_mod_name, {}),
				i(1),
				i(2),
				i(3),
			}),
			fmt("function {}:{}({})\n  {}\nend", {
				f(get_returned_mod_name, {}),
				i(1),
				i(2),
				i(3),
			}),
		}),
		opts
	),
}

return snips
