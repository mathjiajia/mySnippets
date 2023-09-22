local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")

snips = {
	s(
		{ trig = "env", name = "python3 environment", desc = "Declare py3 environment" },
		{ t({ "#!/usr/bin/env python3", "" }) },
		{
			condition = pos.on_top * conds_expand.line_begin,
			show_condition = pos.on_top * pos.line_begin,
		}
	),
}

return snips
