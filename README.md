# Arshlib.nvim

![License](https://img.shields.io/github/license/arsham/arshlib.nvim)

Common library for using in Neovim plugins.

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Util](#util)
   - [dump](#dump)
   - [User Input](#user-input)

## Requirements

- [Neovim 0.6.0](https://github.com/neovim/neovim/releases/tag/v0.6.0)

## Installation

This library depends are the following libraries. Please make sure to add them
as dependencies in your package manager:

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [nvim.lua](https://github.com/norcalli/nvim.lua)

Use your favourite package manager to install this library. Packer example:

```lua
use({
  "arsham/arshlib.nvim",
  requires = { "nvim.lua", "plenary.nvim", "nui.nvim" },
})
```

## Util

In the following examples we assume the `util` is:

```lua
local util = require("arshlib.util")
```

### Dump

Upon requiring `arshlib.util`, a `dump` function is injected in the global
state that can pretty-print any input.

### User Input

This launches a popup buffer for the input:

```lua
util.user_input{
    prompt = "Message: ",
    on_submit = function(value)
        print("Thank you for your note: " .. value)
    end,
}
```

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.

<!--
vim: foldlevel=3
-->
