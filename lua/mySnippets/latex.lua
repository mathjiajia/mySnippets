local M = {}

local cond_obj = require("luasnip.extras.conditions")

local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
	math_environment = true,
}

local MATH_ENVIRONMENTS = {
	aligned = true,
}

local MATH_IGNORE = {
	text_mode = true,
	label_definition = true,
	label_reference = true,
}

local MATH_IGNORE_COMMANDS = {
	SI = true,
	tag = true,
}

local ALIGN_ENVS = {
	multline = true,
	eqnarray = true,
	align = true,
	array = true,
	split = true,
	alignat = true,
	gather = true,
	flalign = true,
}

local BULLET_ENVS = {
	itemize = true,
	enumerate = true,
}

---@param col_offset? number
---@return TSNode|nil
local function get_node(col_offset)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1 -- treesitter is 0-indexed
	col = col + (col_offset or 0)

	return vim.treesitter.get_node({ pos = { row, col } })
end

---@param node TSNode
---@return string|nil
local function get_environment(node)
	local node_text = vim.treesitter.get_node_text(node, 0)
	local first_line = vim.split(node_text, "\n")[1]
	local env_name = first_line:match("\\begin{([^}]+)}"):gsub("%*$", "")
	return env_name
end

---@param node TSNode
---@return string|nil
local function get_command(node)
	local cmd = node:named_child(0)
	if cmd then
		local cmd_name = vim.treesitter.get_node_text(cmd, 0):gsub("^\\", "")
		return cmd_name
	end
end

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
	local node = get_node()
	while node do
		if MATH_IGNORE[node:type()] then
			return false
		elseif MATH_NODES[node:type()] then
			return true
		elseif node:type() == "generic_command" and MATH_IGNORE_COMMANDS[get_command(node)] then
			return false
		elseif node:type() == "generic_environment" and MATH_ENVIRONMENTS[get_environment(node)] then
			return true
		end
		node = node:parent()
	end
	return false
end

---Check if cursor is in treesitter node of 'text'
---@return boolean
local function in_text()
	return not M.in_math()
end

---Check if cursor is in treesitter node of 'math_environment': 'align'
---@return boolean
local function in_align()
	local node = get_node()
	while node do
		if node:type() == "math_environment" and ALIGN_ENVS[get_environment(node)] then
			return true
		end
		node = node:parent()
	end
	return false
end

local function in_bullets()
	local node = get_node()
	while node do
		if node:type() == "generic_environment" and BULLET_ENVS[get_environment(node)] then
			return true
		end
		node = node:parent()
	end
	return false
end

---Check if cursor is in treesitter node of 'math_environment': 'tikzcd'
---@return boolean
-- local function in_tikzcd()
-- 	local node = vim.treesitter.get_node()
-- 	while node do
-- 		if node:type() == "generic_environment" and get_environment(node) == "tikzcd" then
-- 			return true
-- 		end
-- 		node = node:parent()
-- 	end
-- 	return false
-- end

---Check if cursor is in treesitter node of 'generic_command': '\xymatrix'
---@return boolean
local function in_xymatrix()
	local node = get_node()
	while node do
		if node:type() == "generic_command" and get_command(node) == "xymatrix" then
			return true
		end
		node = node:parent()
	end
	return false
end

M.in_math = cond_obj.make_condition(in_math)
M.in_text = cond_obj.make_condition(in_text)
M.in_align = cond_obj.make_condition(in_align)
M.in_bullets = cond_obj.make_condition(in_bullets)
-- M.in_tikzcd = cond_obj.make_condition(in_tikzcd)
M.in_xymatrix = cond_obj.make_condition(in_xymatrix)

return M
