local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Batman'
config.enable_scroll_bar = true

config.ssh_domains = {
  {
    name = 'mahmooz2',
    remote_address = 'mahmooz2',
    username = 'mahmooz',
  },
  {
    name = 'mahmooz2-2',
    remote_address = 'mahmooz2-2',
    username = 'mahmooz',
  },
}

config.font = wezterm.font('iosevka')
config.font_size = 10.0

-- for persistent multiplexing sessions (like tmux)
config.unix_domains = {
  {
    name = 'unix',
  },
}

config.check_for_updates = false

config.keys = {
  {key="1", mods="ALT", action=wezterm.action{ActivateTab=0}},
  {key="2", mods="ALT", action=wezterm.action{ActivateTab=1}},
  {key="3", mods="ALT", action=wezterm.action{ActivateTab=2}},
  {key="4", mods="ALT", action=wezterm.action{ActivateTab=3}},
  {key="5", mods="ALT", action=wezterm.action{ActivateTab=4}},
  {key="6", mods="ALT", action=wezterm.action{ActivateTab=5}},
  {key="7", mods="ALT", action=wezterm.action{ActivateTab=6}},
  {key="8", mods="ALT", action=wezterm.action{ActivateTab=7}},
  {key="9", mods="ALT", action=wezterm.action{ActivateTab=8}},

  {key="s", mods="ALT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  {key="v", mods="ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},

  {key="h", mods="ALT", action=wezterm.action{ActivatePaneDirection="Left"}},
  {key="l", mods="ALT", action=wezterm.action{ActivatePaneDirection="Right"}},
  {key="k", mods="ALT", action=wezterm.action{ActivatePaneDirection="Up"}},
  {key="j", mods="ALT", action=wezterm.action{ActivatePaneDirection="Down"}},

  {key="t", mods="ALT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
}

return config