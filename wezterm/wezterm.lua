local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config.color_scheme = "Catppuccin Macchiato"

config.font_size = 12
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Nerd Font Mono",
})

config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
-- Key mappings
config.keys = {
	{
		key = "n",
		mods = "ALT",
		action = wezterm.action.ToggleFullScreen,
	},
	-- Reload config
	{
		key = "r",
		mods = "LEADER",
		action = act.ReloadConfiguration,
	},
	-- Paste/Copy
	{
		key = "v",
		mods = "CTRL",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = "CMD",
		action = act.CopyTo("ClipboardAndPrimarySelection"),
	},
	-- Create new tab (current pane)
	{
		key = "t",
		mods = "CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- default domain
	{
		key = "n",
		mods = "CTRL",
		action = act.SpawnTab({
			DomainName = "unix",
		}),
	},
	--Pane spliting
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "-",
		mods = "CTRL|ALT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
}

for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

--tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

return config
