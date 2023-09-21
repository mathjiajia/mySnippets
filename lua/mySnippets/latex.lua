local M = {}

local api = vim.api
local ts = vim.treesitter
local cond_obj = require("luasnip.extras.conditions")

local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
	math_environment = true,
}

local ALIGN_ENVIRONMENTS = {
	["{multline}"] = true,
	["{eqnarray}"] = true,
	["{align}"] = true,
	["{array}"] = true,
	["{split}"] = true,
	["{alignat}"] = true,
	["[gather]"] = true,
	["{flalign}"] = true,
}

---get node under the cursor in insert mode (after trigger) for latex
---@return TSNode|nil
local function get_node_at_cursor()
	local cursor = api.nvim_win_get_cursor(0)
	return ts.get_node({ bufnr = 0, pos = { cursor[1] - 1, cursor[2] - 1 } })
end

---Check if cursor is in treesitter node of 'math_environment': 'tikzcd'
---@return boolean
-- local function in_tikzcd()
-- 	local buf = api.nvim_get_current_buf()
-- 	local node = get_node_at_cursor()
-- 	while node do
-- 		if node:type() == "generic_environment" then
-- 			local begin = node:child(0)
-- 			local names = begin and begin:field("name")
--
-- 			if names and names[1] and ts.query.get_node_text(names[1], buf) == "tikzcd" then
-- 				return true
-- 			end
-- 		end
-- 		node = node:parent()
-- 	end
-- 	return false
-- end

---Check if cursor is in treesitter node of 'text'
---@return boolean
local function in_text()
	local node = get_node_at_cursor()
	while node do
		if node:type() == "text_mode" then
			return true
		elseif MATH_NODES[node:type()] then
			return false
		end
		node = node:parent()
	end
	return true
end

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
	local node = get_node_at_cursor()
	while node do
		if node:type() == "text_mode" then
			return false
		elseif MATH_NODES[node:type()] then
			return true
		end
		node = node:parent()
	end
	return false
end

---Check if cursor is in treesitter node of 'math_environment': 'align'
---@return boolean
local function in_align()
	local bufnr = api.nvim_get_current_buf()
	local node = get_node_at_cursor()
	while node do
		if node:type() == "math_environment" then
			local begin = node:child(0)
			local names = begin and begin:field("name")

			if names and names[1] and ALIGN_ENVIRONMENTS[ts.get_node_text(names[1], bufnr):gsub("%*", "")] then
				return true
			end
		end
		node = node:parent()
	end
	return false
end

---Check if cursor is in treesitter node of 'generic_command': '\xymatrix'
---@return boolean
local function in_xymatrix()
	local bufnr = api.nvim_get_current_buf()
	local node = get_node_at_cursor()
	while node do
		if node:type() == "generic_command" then
			local names = node:child(0)
			if names and ts.get_node_text(names, bufnr) == "\\xymatrix" then
				return true
			end
		end
		node = node:parent()
	end
	return false
end

M.in_math = cond_obj.make_condition(in_math)
M.in_text = cond_obj.make_condition(in_text)
M.in_align = cond_obj.make_condition(in_align)
M.in_xymatrix = cond_obj.make_condition(in_xymatrix)

return M
