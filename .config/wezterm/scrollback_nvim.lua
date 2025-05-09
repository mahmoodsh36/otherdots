local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- retrieve the current viewport's text.
  -- pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text()

  -- create a temporary file to pass to vim
  local nameWithoutExtension = os.tmpname()

  -- add ".log" extension
  local name = nameWithoutExtension .. ".log"
  os.rename(nameWithoutExtension, name)

  -- insert scrollback content
  local f, err = io.open(name, "w+")

  if f then
      f:write(scrollback)
      f:flush()
      f:close()

      ssh_domain_name = wezterm.mux.get_window(0):active_pane():get_domain_name()
      if ssh_domain_name ~= "local" then
          local cmd = string.format("scp %q %s:%q", name, ssh_domain_name, name)
          wezterm.log_info("running " .. cmd)
          local ok, exit_type, code = os.execute("timeout 5 " .. cmd)
          -- local output = io.popen(cmd)
      end
      -- open a new window running vim and tell it to open the file
      window:perform_action(
          wezterm.action({
              SpawnCommandInNewTab = {
                  args = { "nvim", name, "+$" },
                  set_environment_variables = {
                      NVIM_LOG_MODE = "true",
                  },
              },
          }),
          pane
      )

      -- give some meaningful name to the new tab
      window:active_tab():set_title(pane:get_title() .. "•log")
  else
      print("error opening file: " .. err)
  end
end)

return {
    key = {
        key = "o",
        mods = "ALT",
        action = wezterm.action({ EmitEvent = "trigger-vim-with-scrollback" }),
    },
}