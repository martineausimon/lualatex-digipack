local function red(text)
  return '\27[91m' .. text .. '\27[0m'
end

local function format(text)
  return '\n' .. text .. '\n\n'
end

local M = {}

function M.error(txt)
  io.stderr:write(format(red("ERROR: " .. txt)))
end

function M.send(txt)
  io.stdout:write(format(txt))
end

function M.ask(txt)
  io.stdout:write(format(txt .. " [y/n]"))
  io.stdout:flush()

  local answer = io.stdin:read("*l")
  answer = answer:lower()

  if answer == "y" or answer == "yes" then
    return true
  elseif answer == "n" or answer == "no" then
    return false
  else
    io.stdout:write("Invalid input. Please answer with 'y' or 'n'.\n")
    return M.ask(txt)
  end
end

function M.check(output_file)
  if require('utils.sh').file_exists(output_file) then
    M.send(string.format("File %q created", output_file))
  else
    M.error(string.format("Can't find %q", output_file))
  end
end

return M
