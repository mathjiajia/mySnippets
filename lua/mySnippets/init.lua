local M = {}

M.setup = function(opts)
	local path = opts.path or vim.fn.stdpath("data") .. "/lazy/mySnippets/luasnippets"
	require("luasnip.loaders.from_lua").lazy_load({ paths = path })
end

return M
