local M = {}

function M.remove_ext(file)
  local parts = {}
  for part in file:gmatch("([^%.]+)") do
    table.insert(parts, part)
  end
  if #parts > 1 then
    table.remove(parts)
  end
  local out = table.concat(parts, ".")
  return out
end

function M.download(name, download_link, destination, zip_location)

  local sh = require('utils.sh')
  local messages = require('utils.messages')

  if not sh.file_exists(destination) then
    local confirm = messages.ask(string.format("Download %s from %s ?", name, download_link))
    if not confirm then os.exit(1)
    else
      if not zip_location then
        sh.check_dependencies("wget")
        sh.cmd(string.format([[wget --quiet --show-progress %q -O %q]], download_link, destination))
      else
        local file = zip_location:gsub(".*/", "")
        sh.check_dependencies({ "wget", "unzip" })
        sh.cmd(string.format([[wget --quiet --show-progress %q -O tmp.zip && unzip -j tmp.zip %q && mv %q %q && rm tmp.zip]], download_link, zip_location, file, destination))
      end
      if not sh.file_exists(destination) then
        messages.error("Download failed, can't find " .. destination)
      end
    end
  else
    messages.send(string.format("File %s already downloaded", destination))
  end
end


return M
