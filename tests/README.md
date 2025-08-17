# Testing miss.nvim

This directory contains comprehensive tests for the miss.nvim Neovim plugin using [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).

## Test Structure

```
tests/
├── plenary/
│   ├── init.lua          # Main test entry point
│   ├── test_miss.lua     # Core plugin tests
│   ├── test_helpers.lua  # Test utilities and mocks
│   └── run.lua           # Test runner script
└── README.md             # This file
```

## Prerequisites

1. **Neovim** (0.8.0 or higher)
2. **plenary.nvim** - Testing framework

## Installation

### Option 1: Using a package manager (recommended)

If you're using lazy.nvim, add to your config:

```lua
{
    "nvim-lua/plenary.nvim",
    config = function()
        require("plenary.test_harness")
    end
}
```

### Option 2: Manual installation

```bash
git clone https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/plenary/start/plenary.nvim
```

## Running Tests

### Method 1: Using Neovim

1. Open Neovim in the plugin directory
2. Run tests:
   ```lua
   :lua require('tests.plenary.init')
   ```

### Method 2: Command line (headless)

```bash
nvim --headless -c "lua require('tests.plenary.run')" -c "quit"
```

### Method 3: Using plenary.nvim directly

```lua
:lua require('plenary.test_harness').test_directory('tests/plenary')
```

## Test Categories

### 1. State Management
- Plugin initialization
- State consistency
- Keymap setup

### 2. File Operations
- File saving
- File resetting
- File opening
- Buffer validation

### 3. Popup Management
- Popup creation
- Popup dimensions
- Key bindings
- Auto-close behavior

### 4. Integration Scenarios
- Complete workflows
- Multiple file operations
- State transitions

### 5. Error Handling
- Invalid buffers
- File system errors
- Graceful degradation

### 6. Configuration
- User preferences
- Default values
- Customization options

## Writing Tests

### Test Structure

```lua
describe("Feature Name", function()
    before_each(function()
        -- Setup before each test
    end)
    
    after_each(function()
        -- Cleanup after each test
    end)
    
    it("should do something specific", function()
        -- Test implementation
        assert.is_true(condition)
    end)
end)
```

### Mocking

The test suite includes comprehensive mocks for:
- Neovim API functions
- File system operations
- User interactions
- Buffer and window management

### Example Test

```lua
it("should setup keymaps correctly", function()
    local keymap_calls = {}
    mock_vim.keymap.set = function(mode, lhs, rhs, opts)
        table.insert(keymap_calls, {mode = mode, lhs = lhs, rhs = rhs, opts = opts})
    end
    
    miss.setup()
    
    assert.equals(1, #keymap_calls)
    assert.equals("n", keymap_calls[1].mode)
    assert.equals("<leader>a", keymap_calls[1].lhs)
end)
```

## Continuous Integration

Tests run automatically on:
- Push to main/develop branches
- Pull requests
- GitHub Actions with Ubuntu latest

## Debugging Tests

### Verbose Output

```lua
:lua require('plenary.test_harness').test_directory('tests/plenary', { verbose = true })
```

### Single Test File

```lua
:lua require('tests.plenary.test_miss')
```

### Break on Failure

```lua
:lua require('plenary.test_harness').test_directory('tests/plenary', { stop_on_failure = true })
```

## Contributing

When adding new features:

1. Write tests first (TDD approach)
2. Ensure all tests pass
3. Add test coverage for edge cases
4. Update this README if needed

## Troubleshooting

### Common Issues

1. **Plenary not found**: Ensure plenary.nvim is installed and in runtime path
2. **Test failures**: Check Neovim version compatibility
3. **Mock issues**: Verify mock functions match expected API signatures

### Getting Help

- Check plenary.nvim documentation
- Review existing test patterns
- Open an issue with test output and error messages
