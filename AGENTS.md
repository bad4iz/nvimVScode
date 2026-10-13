# AGENTS.md

## Repo Shape
- This is an AstroNvim v6 user config, not a Lua package or plugin library.
- Startup is `init.lua` -> `lua/lazy_setup.lua` -> `lua/polish.lua`; `init.lua` only bootstraps `lazy.nvim` and should rarely change.
- Lazy imports run in this order: `AstroNvim/AstroNvim`, `lua/community.lua`, then every module under `lua/plugins/`.
- `lua/community.lua`, `lua/polish.lua`, and the current `lua/plugins/*.lua` files are template stubs guarded by `if true then return ... end`; remove that guard before expecting edits in those files to take effect.
- Do not follow stale `lua/user/*` or dual VSCode/standalone guidance from older tracked files; the current working tree uses the AstroNvim template layout above.

## Commands
- Smoke-load the config after changes with `nvim --headless +qa`.
- There is no `package.json`, task runner, or CI workflow in this repo; use tool binaries directly.
- Formatting is configured by `.stylua.toml`; run `stylua --check .` to check or `stylua .` to format when StyLua is installed.
- Linting is configured by `selene.toml`; run `selene .` when Selene is installed.

## Tooling Notes
- `.stylua.toml` uses 2-space indents, 120 columns, Unix endings, `AutoPreferDouble` quotes, and no call parentheses where StyLua allows it.
- Lua language-server formatting is disabled in `.luarc.json` and `.neoconf.json`; do not rely on `lua_ls` for formatting this repo.
- `lazy-lock.json` pins plugin revisions and should only change as the result of an intentional Lazy sync/update.

## Plugin Edits
- Add active Lazy specs as Lua modules under `lua/plugins/`; `lazy_setup.lua` already imports that directory.
- Put AstroCommunity imports in `lua/community.lua`; it is imported before local plugin overrides.
- Keep plugin-specific configuration in the plugin spec file unless the setting must run after all setup, in which case use `lua/polish.lua` and remove its guard.
