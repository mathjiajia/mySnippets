# nvim-math-snippets

A collection of snippets for [LuaSnips][luasnip].

Example (with [lazy.nvim][lazy]):

```lua
{
    "L3MON4D3/LuaSnip",
    dependencies = { "mathjiajia/nvim-math-snippets" },
    config = function()
        require("luasnip").setup({
            update_events = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        })
        require("luasnip.loaders.from_lua").lazy_load({})
        -- other configuration
    end,
}
```

## mathematics

## Acknowledgements

Inspired by

- [luasnip-latex-snippets.nvim](https://github.com/evesdropper/luasnip-latex-snippets.nvim)
- [latex-snippets](https://github.com/gillescastel/latex-snippets)

[lazy]: https://github.com/folke/lazy.nvim
[luasnip]: https://github.com/L3MON4D3/LuaSnip
