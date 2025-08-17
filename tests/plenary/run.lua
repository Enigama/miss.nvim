-- Test runner for miss.nvim
-- Usage: nvim --headless -c "lua require('tests.plenary.run')"

local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_path) == 0 then
    print("Plenary.nvim not found. Please install it first:")
    print("git clone https://github.com/nvim-lua/plenary.nvim " .. plenary_path)
    return
end

-- Add plenary to runtime path
vim.opt.runtimepath:prepend(plenary_path)

-- Load plenary
require("plenary.test_harness")

-- Run tests
require("tests.plenary.init")

print("Tests completed!")
