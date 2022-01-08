local nvim = require("nvim")
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
  vim.api.nvim_add_user_command(name, command, opts)
end --}}}

---Creates a command from provided specifics on current buffer.
---@param name string
---@param command string|function
---@param opts dict
function M.buffer_command(name, command, opts) --{{{
  opts = opts or {}
  opts.force = true
  vim.api.nvim_buf_add_user_command(0, name, command, opts)
end --}}}

---@class AugroupOpt
---@field name string also the first field. Name of the group. Should be unique.
---@field cmds? AutocmdOpt[] if empty then it only creates the augroup. @see M.autocmd.

---Creates an augroup with a set of autocmds.
---@param opts AugroupOpt
function M.augroup(opts) --{{{
  local name = opts.name or opts[1]
  -- stylua: ignore start
  vim.validate({
    name = { name, function(n) return n ~= "" end, "non empty group name" },
    opts = { opts, "t", true },
  })
  -- stylua: ignore end

  local cmds = opts.cmds or opts[2]
  if not cmds then
    cmds = {}
  end

  nvim.ex.augroup(name)
  nvim.ex.autocmd_("*")
  for _, def in pairs(cmds) do
    M.autocmd(def)
  end
  nvim.ex.augroup("END")
end --}}}

local storage = {} --{{{

---Have to use a global to handle re-requiring this file and losing all of the
-- commands.
__ContextStorage = __ContextStorage or {}
storage._store = __ContextStorage

storage._create = function(f)
  table.insert(storage._store, f)
  return #storage._store
end

function M._exec_command(id, ...)
  storage._store[id](...)
end --}}}

---@class AutocmdOpt
---@field group?   string the group to attach to.
---@field events   string "E1,E2"; or you can set the buffer to true
---@field tergets? string "*.go"
---@field run      string or function
---@field docs?    string is handy when you query verbose command.
---@field buffer?  boolean
---@field silent?  boolean
---@field once?    boolean adds ++once

---Creates a single autocmd. You most likely want to use it in a context of an
-- augroup.
---@param opts AutocmdOpt[]
function M.autocmd(opts) --{{{
  vim.validate({
    opts = { opts, "t" },
  })
  local args = {}

  for k, v in pairs(opts) do
    args[k] = v
    if k == "silent" and v then
      args.silent = "silent!"
    end
    if k == "buffer" and v then
      args.buffer = "<buffer>"
    end
  end

  local events = args.events or args[1]
  local targets = args.targets or args[2] or ""
  local run = args.run or args[3]
  local buffer = args.buffer or ""
  local docs = args.docs or "no documents"
  local silent = args.silent or ""
  local once = args.once and "++once" or ""
  local group = args.group or ""

  local autocmd_str
  if type(run) == "string" then
    autocmd_str = ('execute "%s"'):format(run)
  elseif type(run) == "function" then
    local func_id = storage._create(run)
    autocmd_str = ([[lua require('arshlib.quick')._exec_command(%s) -- %s]]):format(func_id, docs)
  else
    error("Unexpected type to run (" .. docs .. "): " .. tostring(run))
  end

  local def = table.concat({ group, events, targets, buffer, silent, once, autocmd_str }, " ")
  nvim.ex.autocmd(def)
end --}}}

---@class HighlightOpt
---@field style string
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
    ["opt.style"] = { opt.style, "s", true },
    ["opt.guifg"] = { opt.guifg, "s", true },
    ["opt.guibg"] = { opt.guibg, "s", true },
    ["opt.guisp"] = { opt.guisp, "s", true },
    ["opt.ctermfg"] = { opt.ctermfg, "s", true },
    ["opt.ctermbg"] = { opt.ctermbg, "s", true },
  })

  local style = opt.style and "gui = " .. opt.style or "gui = NONE"
  local guifg = opt.guifg and "guifg = " .. opt.guifg or "guifg = NONE"
  local guibg = opt.guibg and "guibg = " .. opt.guibg or "guibg = NONE"
  local guisp = opt.guisp and "guisp = " .. opt.guisp or ""
  local ctermfg = opt.ctermfg and "ctermfg = " .. opt.ctermfg or ""
  local ctermbg = opt.ctermbg and "ctermbg = " .. opt.ctermbg or ""

  local str = table.concat({
    group,
    style,
    guifg,
    guibg,
    ctermfg,
    ctermbg,
    guisp,
  }, " ")
  nvim.ex.highlight(str)
end --}}}

return M

-- vim: fdm=marker fdl=0
