local M = {}

local function calculate_unit()
  local currentfont = font.fonts[font.current()]
  local digit_zero = currentfont.characters[48]
  return digit_zero.width / 7
end

local function pattern_to_wd_dp(pattern,pos)
  local wd,dp
  wd = tonumber(string.sub(pattern,pos,pos))
  if wd == 0 then
    dp = "2mm"
    wd = 1
  else
    dp = "0mm"
  end
  return wd,dp
end

local function add_checksum_if_necessary( str )
  if string.len(str) == 13 then
    return str
  end

  local sum = 0
  local len = string.len(str)
  for i=len,1,-1 do
    if (len - i ) % 2 == 0 then
      sum = sum + tonumber(string.sub(str,i,i)) * 3
    else
      sum = sum + tonumber(string.sub(str,i,i))
    end
  end
  local checksum = (10 - sum % 10) % 10
  return str .. tostring(checksum)
end

local function mkpattern(str)
  local digits_t = {"3211","2221","2122","1411","1132","1231","1114","1312","1213","3112"}
  local mirror_t = {"------","--1-11","--11-1","--111-","-1--11", "-11--1","-111--","-1-1-1","-1-11-","-11-1-"}

  local number = {}
  for i=1,string.len(str) do
    number[i] = tonumber(string.sub(str,i,i))
  end

  local prefix = table.remove(number,1)
  local mirror_str = mirror_t[prefix + 1]

  local pattern = "8010"
  local digits_str

  for i=1,#number do
    digits_str = digits_t[number[i] + 1]
    if string.sub(mirror_str,i,i) == "1" then
      digits_str = string.reverse(digits_str)
    end
    pattern = pattern .. digits_str
    if i==6 then pattern = pattern .. "10101" end
  end
  return pattern .. "010"
end

local function split_number( str )
  return string.match(
    str,"(%d)(%d%d%d%d%d%d)(%d%d%d%d%d%d)"
    )
end

local function add_to_nodelist( head,entry )
  if head then
    local tail = node.tail(head)
    tail.next = entry
    entry.prev = tail
  else
    head = entry
  end
  return head
end

local function mkrule( wd,ht,dp )
  local r = node.new("rule")
  r.width = wd
  r.height = ht
  r.depth = dp
  return r
end

local function mkkern( wd )
  local k = node.new("kern")
  k.kern = wd
  return k
end

local function mkglyph( char )
  local g = node.new("glyph")
  g.char = string.byte(char)
  g.font = font.current()
  g.lang = tex.language
  return g
end

function M.generate_barcode_lua(str, height)
  str = add_checksum_if_necessary(str)

  local u = calculate_unit()
  local nodelist

  local bar_height = height or tex.sp("1cm")

  local pattern = mkpattern(str)
  local wd,dp
  for i=1,string.len(pattern) do
    wd,dp = pattern_to_wd_dp(pattern,i)
    if i % 2 == 0 then
      nodelist = add_to_nodelist(
        nodelist,mkrule(
          wd * u,bar_height,tex.sp(dp)))
    else
      nodelist = add_to_nodelist(
        nodelist,mkkern(wd * u))
    end
  end

  local barcode_top = node.hpack(nodelist)
  barcode_top = add_to_nodelist(
    barcode_top,mkkern(tex.sp("-1.7mm")))

  nodelist = nil
  for i,v in ipairs({split_number(str)}) do
    for j=1,string.len(v) do
      nodelist = add_to_nodelist(
        nodelist,mkglyph(string.sub(v,j,j)))
    end
    if i == 1 then
      nodelist = add_to_nodelist(
          nodelist,mkkern(5 * u))
    elseif i == 2 then
      nodelist = add_to_nodelist(
          nodelist,mkkern(4 * u))
    end
  end
 local barcode_bottom = node.hpack(nodelist)
 barcode_top = add_to_nodelist(
      barcode_top,barcode_bottom)
 local bc = node.vpack(barcode_top)

 node.write(bc)
end

return M
