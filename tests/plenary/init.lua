-- Test entry point for miss.nvim plugin
-- This file is automatically loaded by plenary.nvim

-- Load the plugin module
local miss = require("miss")

-- Run all tests
describe("miss.nvim", function()
    -- Include all test modules
    require("tests.plenary.test_miss")
end)
