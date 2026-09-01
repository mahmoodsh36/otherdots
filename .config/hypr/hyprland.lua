hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

local main_monitor = "eDP-1"

local function setup_workspaces(mon_name)
    for i = 1, 5 do
        if mon_name and mon_name ~= "" then
            hl.workspace_rule({ workspace = tostring(i), monitor = mon_name })
        else
            hl.workspace_rule({ workspace = tostring(i) })
        end
    end
end

local function detect_and_setup_workspaces()
    local monitors = hl.get_monitors()
    if monitors and #monitors > 0 then
        local has_edp = false
        for _, m in ipairs(monitors) do
            if m.name == "eDP-1" then
                has_edp = true
                break
            end
        end
        if has_edp then
            main_monitor = "eDP-1"
        else
            main_monitor = monitors[1].name
        end
        setup_workspaces(main_monitor)
    else
        setup_workspaces(nil)
    end
end

detect_and_setup_workspaces()
hl.on("monitor.added", function(monitor)
    detect_and_setup_workspaces()
end)

local terminal = "wezterm"
local fileManager = "dolphin"
local mainMod = "SUPER"

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("swww-daemon & disown; swww img ~/.cache/wallpaper")
    hl.exec_cmd("sudo python ~/work/keys/keys.py -d")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = { colors = {"rgba(aa5555ee)", "rgba(aa5599ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        allow_tearing = false,
        layout = "scroller", -- scroller plugin
    },
    decoration = {
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        enable_anr_dialog = false,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})
hl.device({
    name = "wacom-intuos-bt-s-pen",
    output = "eDP-1",
})

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, silent = true }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext; hyprctl dispatch bringactivetotop"))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext,prev"))

hl.define_submap("mymap2", function()
    hl.bind("1", hl.dsp.exec_cmd("hyprctl keyword input:kb_layout us; hyprctl dispatch submap reset"))
    hl.bind("2", hl.dsp.exec_cmd("hyprctl keyword input:kb_layout il; hyprctl dispatch submap reset"))
    hl.bind("3", hl.dsp.exec_cmd("hyprctl keyword input:kb_layout ara; hyprctl dispatch submap reset"))
    hl.bind("catchall", hl.dsp.exec_cmd("hyprctl dispatch submap reset"))
    hl.bind("escape", hl.dsp.exec_cmd("hyprctl dispatch submap reset"))
end)
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("hyprctl dispatch submap mymap2"))

hl.bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("control_volume.sh +3%"))
hl.bind(mainMod .. " + ALT + j", hl.dsp.exec_cmd("control_volume.sh -3%"))

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })

hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({ match = { class = "^.*(popup).*$" }, float = true })
hl.window_rule({ match = { title = "^.*(popup).*$" }, float = true })
hl.window_rule({ match = { title = "^.*(popup).*$" }, stay_focused = true })
hl.window_rule({ match = { title = "^.*(popup).*$" }, pin = true })
hl.window_rule({ match = { title = "bar" }, monitor = main_monitor })
