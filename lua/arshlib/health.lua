local M = {}
local health = require("health")

local libs = {
  plenary = "nvim-lua/plenary.lua",
  ["nui.input"] = "MunifTanjim/nui.nvim",
}

M.check = function()
  health.report_start("Arshlib Health Check")
  for name, package in pairs(libs) do
    if not pcall(require, name) then
      health.report_error(package .. " was not found", {
        'Please install "' .. package .. '"',
      })
    else
      health.report_ok(package .. " is installed")
    end
  end
end

return M
