local messages = require('utils.messages')

local M = {}

function M.cmd(cmd)
  local p = io.popen(cmd)
  if not p or p == "" then return end
  local output = p:read("*a")
  p:close()
  return output
end

function M.file_exists(name)
  local f = io.open(name,"r")

  if not f then
    return false
  end

  io.close(f)
  return true
end

function M.check_dependencies(prgs)
  if type(prgs) == "string" then prgs = { prgs } end

  local missing = {}

  for _, prg in ipairs(prgs) do
    local result = M.cmd(string.format("which %s 2>/dev/null", prg))
    if not result or result == "" then
      table.insert(missing, prg)
    end
  end

  if #missing > 0 then
    local prg
    if type(missing) == "table" then
      prg = table.concat(missing, "\n")
    else
      prg = missing
    end
    messages.error("This tool require the following packages:\n"..prg)
    os.exit(1)
  end

  return true
end

function M.check_filetype(input, expected_type)
  local _, succes = input:gsub(expected_type .. '$', '')
  if succes == 0 then
    messages.error("Input file must be a " .. expected_type)
    os.exit(1)
  end

  return true
end

return M
