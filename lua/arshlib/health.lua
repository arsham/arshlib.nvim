local M = {}

local libs = {
  plenary = "nvim-lua/plenary.lua",
  ["nui.input"] = "MunifTanjim/nui.nvim",
}

M.check = function()
  vim.health.start("Arshlib Health Check")
  for name, package in pairs(libs) do
    if not pcall(require, name) then
      vim.health.error(package .. " was not found", {
        'Please install "' .. package .. '"',
      })
    else
      vim.health.ok(package .. " is installed")
    end
  end
end

return M
