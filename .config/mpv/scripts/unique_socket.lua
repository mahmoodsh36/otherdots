local utils = require 'mp.utils'
local msg = require 'mp.msg'

local data_dir_env = os.getenv("DATA_DIR")

local function get_command_output(cmd_args)
    local res = utils.subprocess({
        args = cmd_args,
        cancellable = false,
    })
    
    if res.status == 0 then
        -- remove trailing newline
        local output = string.gsub(res.stdout, "\n$", "")
        return output
    else
        return nil -- command failed
    end
end

if not data_dir_env or data_dir_env == "" then
    local output = get_command_output({"zsh", "-l", "-c", "echo -n $DATA_DIR"})
    data_dir_env = output
    if not data_dir_env or data_dir_env == "" then
      msg.warn("DATA_DIR environment variable is not set!")
      msg.warn("falling back to /tmp/ for IPC socket.")
      data_dir_env = "/tmp"
    end
end

if string.sub(data_dir_env, -1) ~= "/" then
    data_dir_env = data_dir_env .. "/"
end

local socket_dir = data_dir_env .. "mpv_data/sockets/"
local pid = utils.getpid()

-- ensure dir exists
-- os.execute("mkdir -p '" .. socket_dir .. "'")

local socket_path = socket_dir .. "mpv_socket_" .. pid

mp.set_property("input-ipc-server", socket_path)
msg.info("IPC Socket initialized at: " .. socket_path)
