local M = {}

---Convert a hex color to RGB.
---@param hex string
---@return number red
---@return number green
---@return number blue
function M.hex_to_rgb(hex) --{{{
  local r, g, b = hex:match("(%x%x)(%x%x)(%x%x)")
  return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
end --}}}

---Convert a RGB colour to HSV.
---@param red number
---@param green number
---@param blue number
---@return number hue
---@return number saturation
---@return number value
function M.rgb_to_hsv(red, green, blue) --{{{
  local max = math.max(red, green, blue)
  local min = math.min(red, green, blue)
  local hue
  local saturation
  local value = max

  if max == min then
    hue = 0
    saturation = 0
  else
    local delta = max - min
    if max == red then
      hue = (green - blue) / delta
    elseif max == green then
      hue = 2 + (blue - red) / delta
    else
      hue = 4 + (red - green) / delta
    end
    hue = hue * 60
    if hue < 0 then
      hue = hue + 360
    end
    saturation = delta / value
  end

  return hue, saturation, value
end --}}}

---Convert a HSV colour to RGB.
---@param hue number
---@param saturation number
---@param value number
---@return number red
---@return number green
---@return number blue
function M.hsv_to_rgb(hue, saturation, value) --{{{
  if saturation == 0 then
    return value, value, value
  end

  local hue_sector = math.floor(hue / 60)
  local hue_sector_offset = (hue / 60) - hue_sector

  local p = math.floor(value * (1 - saturation))
  local q = math.floor(value * (1 - saturation * hue_sector_offset))
  local t = math.floor(value * (1 - saturation * (1 - hue_sector_offset)))

  if hue_sector == 0 then
    return value, t, p
  elseif hue_sector == 1 then
    return q, value, p
  elseif hue_sector == 2 then
    return p, value, t
  elseif hue_sector == 3 then
    return p, q, value
  elseif hue_sector == 4 then
    return t, p, value
  elseif hue_sector == 5 then
    return value, p, q
  end
end --}}}

---Convert a RGB colour to hex code.
---@param red number
---@param green number
---@param blue number
---@return string hex code
function M.rgb_to_hex(red, green, blue) --{{{
  return string.format("#%02x%02x%02x", red, green, blue)
end --}}}

M.colours = { --{{{
  black = 30,
  red = 31,
  green = 32,
  yellow = 33,
  blue = 34,
  magenta = 35,
  cyan = 36,
}
--}}}
---Returns a string that prints a colorized version of the given table suitable
-- for terminal output.
---@param colour any item from the colours table.
---@param text string text to colorize.
---@return string
function M.ansi_color(colour, text) --{{{
  -- selene: allow(bad_string_escape)
  return ("\x1b[%s;1;m%s\x1b[m"):format(colour, text)
end --}}}

return M

-- vim: fdm=marker fdl=0
