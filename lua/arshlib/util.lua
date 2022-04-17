local M = {
  profiler_enabled = false,
  profiler_path = vim.env.HOME .. "/tmp",
}

---Prints the time it takes to run the fn function if the vim.g.run_profiler is
-- set to true.
---@param name string|function if a function, you can ignore the fn
---@param fn? function
function M.profiler(name, fn) --{{{
  if type(name) == "function" then
    fn = name
    name = "unknown"
  end
  if not M.profiler_enabled then
    fn()
    return
  end
  local filename = M.profiler_path .. "/nvim_profiler_" .. name .. ".log"
  local msg = "Profile results are at " .. filename

  require("plenary.profile").start(filename, { flame = true })
  fn()
  require("plenary.profile").stop()
  vim.notify(msg, "info", {
    title = name,
  })
end --}}}

---Prints the time it takes to run the fn function.
---@param fn function
function M.timeit(fn) --{{{
  local start = vim.loop.hrtime()
  fn()
  local msg = ("%fs"):format((vim.loop.hrtime() - start) / 1e6)
  print(msg)
end --}}}

---Dumps any values
---@vararg any
-- selene: allow(global_usage)
function _G.dump(...) --{{{
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end --}}}

---mkdir_home creates a new folder in $HOME if not exists.
---@param dir string
---@return boolean #success result
function M.mkdir_home(dir) --{{{
  local path = vim.env.HOME .. "/" .. dir
  local p = require("plenary.path"):new(path)
  if not p:exists() then
    return p:mkdir()
  end
  return true
end --}}}

local popup_options = { --{{{
  border = {
    style = "rounded",
    highlight = "FloatBorder",
  },
  position = "50%",
  size = {
    width = "80%",
    height = "100%",
  },
}
--}}}

---@class input_opts
---@field on_submit? fun(value: string) the results will be passed
---@field prompt? string

---Takes the user input in a popup.
---@param opts input_opts to override the vim.notify config table.
function M.user_input(opts) --{{{
  local conf = {
    prompt = "> ",
    on_submit = function(value)
      vim.notify(value, vim.lsp.log_levels.INFO, {
        title = "User Input",
        timeout = 2000,
      })
    end,
  }

  conf = vim.tbl_deep_extend("force", conf, opts)
  local input = require("nui.input")(popup_options, {
    prompt = conf.prompt,
    zindex = 10,
    on_submit = conf.on_submit,
  })

  input:mount()
  input:map("i", "<esc>", input.input_props.on_close, {})
  local event = require("nui.utils.autocmd").event

  input:on(event.BufHidden, function()
    vim.schedule(function()
      input:unmount()
    end)
  end)
end --}}}

return M

-- vim: fdm=marker fdl=0
