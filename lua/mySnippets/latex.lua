local M = {}

local get_node_text = vim.treesitter.get_node_text
local cond_obj = require("luasnip.extras.conditions")

local MATH_NODES = {
	displayed_equation = true,
	inline_formula = true,
	math_environment = true,
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

---Check if cursor is in treesitter node of 'math_environment': 'tikzcd'
---@return boolean
-- local function in_tikzcd()
-- 	local node = vim.treesitter.get_node()
-- 	while node do
-- 		if node:type() == "generic_environment" then
-- 			local begin = node:child(0)
-- 			local names = begin and begin:field("name")
--
-- 			if names and names[1] and get_node_text(names[1], 0) == "tikzcd" then
-- 				return true
-- 			end
-- 		end
-- 		node = node:parent()
-- 	end
-- 	return false
-- end

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
	local node = vim.treesitter.get_node()
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

---Check if cursor is in treesitter node of 'text'
---@return boolean
local function in_text()
	return not M.in_math()
end

---Check if cursor is in treesitter node of 'math_environment': 'align'
---@return boolean
local function in_align()
	local node = vim.treesitter.get_node()
	while node do
		if node:type() == "math_environment" then
			local begin = node:child(0)
			local names = begin and begin:field("name")

			if names and names[1] and ALIGN_ENVS[get_node_text(names[1], 0):gsub("{(%w+)%s*%*?}", "%1")] then
				return true
			end
		end
		node = node:parent()
	end
	return false
end

local function in_bullets()
	local node = vim.treesitter.get_node()
	while node do
		if node:type() == "generic_environment" then
			local begin = node:child(0)
			local names = begin and begin:field("name")

			if names and names[1] and BULLET_ENVS[get_node_text(names[1], 0):gsub("{(%w+)}", "%1")] then
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
	local node = vim.treesitter.get_node()
	while node do
		if node:type() == "generic_command" then
			local names = node:child(0)
			if names and get_node_text(names, 0) == "\\xymatrix" then
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
M.in_bullets = cond_obj.make_condition(in_bullets)
M.in_xymatrix = cond_obj.make_condition(in_xymatrix)

return M
