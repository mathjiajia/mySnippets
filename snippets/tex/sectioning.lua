local snips = {}

local sec_snippet = require("mySnippets.utils").sec_snippet

local sec_specs = {
	cha = "chapter",
	sec = "section",
	ssec = "section*",
	sub = "subsection",
	ssub = "subsection*",
}

local env_snippets = {}

for k, v in pairs(sec_specs) do
	table.insert(env_snippets, sec_snippet({ trig = k }, v))
end

vim.list_extend(snips, env_snippets)

return snips
