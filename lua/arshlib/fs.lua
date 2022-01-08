local M = {}

---Returns a pair of canonical name and the module name.
---@param filename string
---@return string
---@return string
---@return boolean when the filename matches a correct module.
local function try_filename(filename)
  local patterns = {
    [[/nvim/lua/(.+.lua)$]],
    [[/nvim/([%a\/]+.+.lua)$]],
    [[nvim/lua/(.+.lua)$]],
    [[lua/(.+.lua)$]],
    [[colors/(.+.lua)$]],
    [[(.+.lua)$]],
  }
  for _, pattern in ipairs(patterns) do
    local name = filename:match(pattern)
    if name then
      local mod_name = name:match("(.+).lua$")
      mod_name, _ = mod_name:gsub("/", ".")
      return name, mod_name, true
    end
  end
  return "", "", false
end

---@class file_module
---@field module string the module name
---@field filepath string the filepath
---@field name string the name of the file

---Returns a pair of canonical name and the module name.
---@param filename string
---@return file_module
---@return boolean true if it can load the module and the module is in the path.
function M.file_module(filename)
  local mod = {}
  local name, mod_name, ok = try_filename(filename)

  if ok then
    mod.module = mod_name
    mod.filepath = filename
    mod.name = name
  end
  return mod, ok
end

return M
