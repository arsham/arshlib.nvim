local M = {}
local health = require("health")

M.check = function()
  health.report_start("Arshlib Health Check")
  if not pcall(require, "plenary") then
    health.report_error("plenary.nvim was not found", {
      'Please install "nvim-lua/plenary.nvim"',
    })
  else
    health.report_ok("plenary.nvim is installed")
  end

  if not pcall(require, "nui.input") then
    health.report_error("nui.nvim was not found", {
      'Please install "MunifTanjim/nui.nvim"',
    })
  else
    health.report_ok("nui.nvim is installed")
  end

  if not pcall(require, "nvim") then
    health.report_error("nvim.lua was not found", {
      'Please install "norcalli/nvim.lua"',
    })
  else
    health.report_ok("nvim.lua is installed")
  end
end

return M
