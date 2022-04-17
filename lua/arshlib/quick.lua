local M = {}

function M.cwr() --{{{
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end --}}}

---Executes a command in normal mode.
---@param mode string @see vim.api.nvim_feedkeys().
---@param motion string what you mean to do in normal mode.
function M.normal(mode, motion) --{{{
  local sequence = vim.api.nvim_replace_termcodes(motion, true, false, false)
  vim.api.nvim_feedkeys(sequence, mode, true)
end --}}}

---Pushes the current location to the jumplist and calls the fn callback, then
-- centres the cursor.
---@param fn function
function M.call_and_centre(fn) --{{{
  M.normal("n", "m'")
  fn()
  vim.schedule(function()
    M.normal("n", "zz")
  end)
end --}}}

---Pushes the current location to the jumplist and calls the cmd, then centres
-- the cursor.
---@param cmd string
function M.cmd_and_centre(cmd) --{{{
  M.normal("n", "m'")
  vim.cmd(cmd)
  vim.schedule(function()
    M.normal("n", "zz")
  end)
end --}}}

---Creates a command from provided specifics.
---@param name string
---@param command string|function
---@param opts dict
function M.command(name, command, opts) --{{{
  opts = opts or {}
  opts.force = true
  vim.api.nvim_create_user_command(name, command, opts)
end --}}}

---Creates a command from provided specifics on current buffer.
---@param name string
---@param command string|function
---@param opts dict
function M.buffer_command(name, command, opts) --{{{
  opts = opts or {}
  opts.force = true
  vim.api.nvim_buf_create_user_command(0, name, command, opts)
end --}}}

---@class AugroupOpt
---@field name string also the first field. Name of the group. Should be unique.
---@field cmds? AutocmdOpt[] if empty then it only creates the augroup. @see M.autocmd.

---@class AutocmdOpt
---@field group?   string the group to attach to.
---@field events   string "E1,E2"; or you can set the buffer to true
---@field tergets? string "*.go"
---@field run      string or function
---@field desc?    string is handy when you query verbose command.
---@field buffer?  boolean
---@field silent?  boolean
---@field once?    boolean adds ++once

---Creates a single autocmd. You most likely want to use it in a context of an
-- augroup.
---@param opts AutocmdOpt[]

---Creates an augroup with a set of autocmds.
---@param opts AugroupOpt
function M.augroup(name, opts) --{{{
  if vim.fn.has("nvim-0.7.0") == 0 then
    vim.notify_once("require vim v0.7.0 or higher")
    return
  end

  -- stylua: ignore start
  vim.validate({
    name = { name, function(n) return n ~= "" end, "non empty group name" },
    opts = { opts, "t", true },
  })
  opts = opts or {}
  -- stylua: ignore end

  vim.api.nvim_create_augroup(name, {})
  for _, def in ipairs(opts) do
    def.group = name
    M.autocmd(def)
  end
end --}}}

---Creates a single autocmd. You most likely want to use it in a context of an
-- augroup.
---@param opts AutocmdOpt[]
function M.autocmd(opts) --{{{
  if vim.fn.has("nvim-0.7.0") == 0 then
    vim.notify_once("require vim v0.7.0 or higher")
    return
  end

  vim.validate({
    opts = { opts, "t" },
    ["opts.callback"] = { opts.callback, { "s", "f" } },
    ["opts.events"] = { opts.events, { "s", "t" } },
    ["opts.group"] = { opts.group, "s", true },
  })

  if opts.buffer then
    opts.pattern = "<buffer>"
    opts.buffer = nil
  end

  local events = opts.events
  opts.events = nil

  vim.api.nvim_create_autocmd(events, opts)
end --}}}

---@class HighlightOpt
---@field style string
---@field link? string if defined, everything else is ignored
---@field guifg string
---@field guibg string
---@field guisp string
---@field ctermfg string
---@field ctermbg string

---Create a highlight group.
---@param group string name of the highlight group.
---@param opt HighlightOpt additional properties.
function M.highlight(group, opt) --{{{
  vim.validate({
    opt = { opt, "t" },
  })

  vim.api.nvim_set_hl(0, group, opt)
end --}}}

---Returns the contents of the visually selected region.
-- @return string
M.selection_contents = function()
  local mode = vim.api.nvim_get_mode().mode
  local from = vim.fn.getpos("v")
  local to = vim.fn.getcurpos()
  if from[2] > to[2] then
    from, to = to, from
  end

  if mode == "V" or mode == "CTRL-V" then
    return vim.api.nvim_buf_get_lines(0, from[2] - 1, to[2], false)
  end

  -- if on the same line but from right to left
  if from[2] == to[2] and from[3] > to[3] then
    from, to = to, from
  end

  local num_lines = to[2] - from[2] + 1
  local lines = vim.api.nvim_buf_get_lines(0, from[2] - 1, to[2], false)
  lines[1] = string.sub(lines[1], from[3], -1)
  if num_lines == 1 then
    lines[num_lines] = string.sub(lines[num_lines], 1, to[3] - from[3] + 1)
  else
    lines[num_lines] = string.sub(lines[num_lines], 1, to[3])
  end

  return table.concat(lines, "\n")
end

return M

-- vim: fdm=marker fdl=0
