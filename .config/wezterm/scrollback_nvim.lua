local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- retrieve the current viewport's text.
  -- pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text(2000)

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

      -- wait "enough" time for vim to read the file before we remove it.
      -- The window creation and process spawn are asynchronous
      -- wrt. running this script and are not awaitable, so we just pick
      -- a number.
      wezterm.sleep_ms(1000)
      os.remove(name)
  else
      print("Error opening file: " .. err)
  end
end)

return {
    key = {
        key = "o",
        mods = "ALT",
        action = wezterm.action({ EmitEvent = "trigger-vim-with-scrollback" }),
    },
}