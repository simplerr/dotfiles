local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on("gui-startup", function(cmd)
  local mux = wezterm.mux

  local tab, pane, window = mux.spawn_window(cmd or {})

  local right = pane:split{direction="Right", size=0.5}
  pane:split{direction="Bottom", size=0.5}
  right:split{direction="Bottom", size=0.5}
end)

return {
  -- Appearance
  --color_scheme = "Builtin Solarized Dark",
  color_scheme = "Dracula",
  font_size = 10.0,
  hide_tab_bar_if_only_one_tab = false,
  enable_tab_bar = true,

  -- Status line equivalent
  -- (WezTerm has no tmux-style status bar, but you can show time in the tab bar)
  use_fancy_tab_bar = true,

  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.6,
  },

  keys = {
    -- Window navigation (tabs in wezterm)
    {key="1", mods="CTRL", action=act.ActivateTab(0)},
    {key="2", mods="CTRL", action=act.ActivateTab(1)},
    {key="3", mods="CTRL", action=act.ActivateTab(2)},
    {key="4", mods="CTRL", action=act.ActivateTab(3)},
    {key="5", mods="CTRL", action=act.ActivateTab(4)},

    {key="q", mods="ALT", action=act.ActivateTab(0)},
    {key="w", mods="ALT", action=act.ActivateTab(1)},
    {key="e", mods="ALT", action=act.ActivateTab(2)},

    {key="n", mods="ALT", action=act.ActivateTabRelative(-1)},
    {key="m", mods="ALT", action=act.ActivateTabRelative(1)},

    -- Pane navigation
    {key="h", mods="ALT", action=act.ActivatePaneDirection("Left")},
    {key="j", mods="ALT", action=act.ActivatePaneDirection("Down")},
    {key="k", mods="ALT", action=act.ActivatePaneDirection("Up")},
    {key="l", mods="ALT", action=act.ActivatePaneDirection("Right")},

    -- Copy mode (wezterm has its own)
    {key="Enter", mods="ALT", action=act.ActivateCopyMode},

    -- Toggle pane zoom
    {key="z", mods="ALT", action=act.TogglePaneZoomState},

    {key="h", mods="ALT|SHIFT", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="v", mods="ALT|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},

    {key="v", mods="CTRL", action=act.PasteFrom("Clipboard")},
  },

  -- Copy/paste behavior
  -- (WezTerm integrates with system clipboard by default)
  mouse_bindings = {
    {
      event={Up={streak=1, button="Left"}},
      mods="CTRL",
      action=act.ExtendSelectionToMouseCursor("Cell"),
    },
  },
}
