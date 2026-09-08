local wezterm = require 'wezterm'
local scrollback_nvim = require("scrollback_nvim")

local config = wezterm.config_builder()

-- config.color_scheme = 'Batman'
config.enable_scroll_bar = true

-- "RESIZE" makes it disable the titlebar
config.window_decorations = "RESIZE"
config.enable_wayland = true

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

-- venus accelerates vulkan only, its gl is too old for wezterm so mesa falls back to software llvmpipe. webgpu is the gpu frontend here.
local vm_env = os.getenv("IS_VM")
local is_vm = (vm_env == "1") or (vm_env ~= "0" and file_exists("/run/opengl-driver/share/vulkan/icd.d/virtio_icd.aarch64.json"))
if is_vm then
  config.front_end = "WebGpu"
  local ok, gpus = pcall(function() return wezterm.gui.enumerate_gpus() end)
  if ok and gpus then
    for _, gpu in ipairs(gpus) do
      if gpu.backend == "Vulkan" and gpu.device_type ~= "Cpu" then
        config.webgpu_preferred_adapter = gpu
        break
      end
    end
  end
  config.animation_fps = 1
end

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
  {
    name = 'mahmooz3',
    remote_address = 'mahmooz3',
    username = 'mahmooz',
  },
  {
    name = 'mahmooz4',
    remote_address = 'mahmooz4',
    username = 'mahmooz',
  },
}

config.font = wezterm.font('fantasque sans mono')
config.font_size = 13.0

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

config.initial_rows = 36
config.initial_cols = 160

config.scrollback_lines = 50000

-- local nvim_utils = require 'nvim_utils'
wezterm.log_info("config loaded?")

table.insert(config.keys, scrollback_nvim.key)

return config
