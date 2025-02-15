# Miss - Unsaved Files Manager for Neovim

![Neovim](https://img.shields.io/badge/Neovim-%3E=0.5-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green)

Miss is a Neovim plugin that helps manage unsaved files. It provides a popup window listing all modified buffers, allowing you to quickly save or open them in new tabs.

## Features

- Lists all unsaved files in a floating popup window.
- Save selected files directly from the popup.
- Open selected files in a new tab.
- Easy-to-use keybindings.

## Installation

### Using `packer.nvim`

```lua
use 'Enigama/miss.nvim'
```

### Using `vim-plug`

```vim
Plug 'Enigama/miss.nvim'
```

## Usage

To list unsaved files, run:

```vim
:lua require('miss').list_unsaved_buffers()
```

Or use the default keybinding:

```vim
<leader>a
```

## Keybindings

| Key            | Action                              |
| -------------- | ----------------------------------- |
| `<leader>a`    | Show popup with unsaved files       |
| `s`            | Save selected file and refresh list |
| `<CR>` (Enter) | Open selected file in a new tab     |
| `q`            | Close the popup                     |

## Configuration

Miss works out of the box but can be initialized manually:

```lua
require('miss').setup()
```

## API

### `require('miss').setup()`

Initializes the plugin and binds `<leader>a` to open the popup.

### `require('miss').list_unsaved_buffers()`

Displays a floating popup window with unsaved files.

## License

This plugin is released under the MIT License.
