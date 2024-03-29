# Arshlib.nvim

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/arsham/arshlib.nvim)
![License](https://img.shields.io/github/license/arsham/arshlib.nvim)

Common library for using in Neovim plugins.

1. [Requirements](#requirements)
2. [Installation](#installation)
   - [Packer](#packer)
   - [Lazy](#lazy)
3. [Quick](#quick)
   - [Normal](#normal)
4. [Util](#util)
   - [User Input](#user-input)
5. [Tables](#tables)
6. [Colour](#colour)
7. [Strings](#strings)
8. [FS](#fs)
9. [LSP](#lsp)
10. [License](#license)

## Requirements

This library supports [Neovim
v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0) and newer.

### Update

Some functionalities such as creating augroup and autocmd have been provided by
newer version of Neovim and are removed from this library. If you rely on these
functionalities please pin this library to `86a8bbb` commit, or use the
Neovim's equivalent.

## Installation

This library depends are the following libraries. Please make sure to add them
as dependencies in your package manager:

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

Use your favourite package manager to install this library.

### Packer

```lua
use({
  "arsham/arshlib.nvim",
  requires = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
})
```

### Lazy

```lua
{
  "arsham/arshlib.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  }
}
```

## Quick

`arshlib.quick` provides quick shortcuts for commonly used Neovim functions.

| Method                               | Notes                                                |
| :----------------------------------- | :--------------------------------------------------- |
| `normal(mode, motion)`               | Execute a command in normal mode                     |
| `call_and_centre(fn)`                | Centre the cursor after calling fn                   |
| `cmd_and_centre(cmd)`                | Centre the cursor after executing Ex command         |
| `command(name, comand, opts)`        | Shortcut for `nvim_create_user_command`              |
| `buffer_command(name, comand, opts)` | Shortcut for `nvim_buf_create_user_command`          |
| `selection_contents()`               | Returns the contents of the visually selected region |

### Normal

Executes a normal command. For example:

```lua
quick.normal("n", "y2k")
```

See `:h feedkeys()` for values of the mode.

## Util

In the following examples we assume the `util` is:

```lua
local util = require("arshlib.util")
```

### User Input

This launches a popup buffer for the input:

```lua
util.user_input({
  prompt = "Message: ",
  on_submit = function(value)
    print("Thank you for your note: " .. value)
  end,
})
```

## Tables

`arshlib.colour` module augments the internal `table` with new methods that can
be chained. A `_t` is injected in the global space that can be used to create
new `Table`s or convert a normal `table` to the type of `Table`. Methods that
require a `Table` instance, if they receive a `table` instance, they will
convert them automatically.

If a return value is of `Table` type, the returned value is **always** a new
instance.

| Method             | Notes                                |
| :----------------- | :----------------------------------- |
| `filter(fn)`       |                                      |
| `map(fn)`          |                                      |
| `values()`         |                                      |
| `slice(f, l, s)`   | Slice with step                      |
| `merge(other)`     |                                      |
| `find_first(fn)`   |                                      |
| `contains_fn(fn)`  |                                      |
| `contains(string)` |                                      |
| `reverse()`        |                                      |
| `shuffle()`        |                                      |
| `shunk(size)`      | Returns chunks of tables             |
| `unique(fn)`       |                                      |
| `sort(fn)`         |                                      |
| `exec(fn)`         | Execute on the whole table           |
| `when(bool)`       | Returns an empty Table if v is false |
| `map_length()`     | includes the key-value pairs         |

## Colour

`arshlib.colour` module provides functionalities around colours.

| Method                      | Notes                       |
| :-------------------------- | :-------------------------- |
| `hex_to_rgb(hex)`           |                             |
| `rgb_to_hsv(r, g, b)`       |                             |
| `hsv_to_rgb(h, s, v)`       |                             |
| `rgb_to_hex(r, g, b)`       |                             |
| `andi_colour(colour, text)` | Used for terminal colouring |

## Strings

`arshlib.strings` injects some methods into the `string` std module.

| Method            |
| :---------------- |
| `title_case(str)` |

## FS

`arshlib.fs` provides some file-system functionalities.

| Method                  | Notes                                |
| :---------------------- | :----------------------------------- |
| `file_module(filename)` | Returns module name and the filepath |

## LSP

`arshlib.lsp` provides useful tools for interacting with LSP.

| Method                            | Notes                                                             |
| :-------------------------------- | :---------------------------------------------------------------- |
| `is_lsp_attached()`               |                                                                   |
| `has_lsp_capability(capability)`  | True if at least one of the LSP servers has the given capability. |
| `get_diagnostics_count(severity)` |                                                                   |
| `diagnostics_exist(severity)`     |                                                                   |
| `diagnostic_errors()`             | Count                                                             |
| `diagnostic_warnings()`           | Count                                                             |
| `diagnostic_hints()`              | Count                                                             |
| `diagnostic_info()`               | Count                                                             |
| `go_mod_tidy(bufnr,`filename)     | Executes go.mod tidy.                                             |
| `go_mod_check_upgrades(filename)` | Checks for dependency updates and adds to the quickfix list.      |

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.

<!--
vim: fdl=1 cole=0
-->
