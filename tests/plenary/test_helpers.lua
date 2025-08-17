-- Test helpers for miss.nvim plugin tests

local M = {}

-- Mock vim API functions
function M.create_mock_vim()
    return {
        api = {
            nvim_list_bufs = function() return {1, 2, 3} end,
            nvim_buf_get_option = function(buf, option)
                if option == "modified" then
                    if buf == 1 then return true
                    elseif buf == 2 then return true
                    else return false end
                end
                return ""
            end,
            nvim_buf_get_name = function(buf)
                if buf == 1 then return "/test/file1.txt"
                elseif buf == 2 then return "/test/file2.txt"
                else return "" end
            end,
            nvim_win_is_valid = function() return true end,
            nvim_win_close = function() end,
            nvim_create_buf = function() return 999 end,
            nvim_buf_set_lines = function() end,
            nvim_open_win = function() return 888 end,
            nvim_buf_set_keymap = function() end,
            nvim_create_autocmd = function() end,
            nvim_get_current_buf = function() return 1 end,
            nvim_win_get_cursor = function() return {1, 0} end,
            nvim_buf_get_lines = function() return {"/test/file1.txt"} end,
            nvim_buf_call = function(buf, func) func() end,
            nvim_command = function() end,
            nvim_set_current_buf = function() end,
            nvim_win_get_buf = function() return 999 end
        },
        fn = {
            bufnr = function() return 1 end
        },
        loop = {
            cwd = function() return "/test" end
        },
        o = {
            columns = 100,
            lines = 30
        },
        schedule = function(func) func() end,
        notify = function() end,
        log = {
            levels = {
                INFO = 1,
                WARN = 2
            }
        },
        keymap = {
            set = function() end
        },
        ui = {
            select = function(items, opts, cb)
                cb("Yes")
            end
        }
    }
end

-- Create a mock buffer with specific properties
function M.create_mock_buffer(buf_id, name, modified)
    return {
        id = buf_id,
        name = name,
        modified = modified or false
    }
end

-- Create a mock window configuration
function M.create_mock_window_config()
    return {
        width = 50,
        height = 20,
        border = "rounded",
        style = "minimal"
    }
end

-- Assert buffer state
function M.assert_buffer_state(buf, expected_name, expected_modified)
    assert.equals(expected_name, buf.name)
    assert.equals(expected_modified, buf.modified)
end

-- Mock file system operations
function M.mock_file_operations()
    local operations = {}
    
    local mock_fs = {
        write = function(file_path)
            table.insert(operations, {action = "write", file = file_path})
            return true
        end,
        reset = function(file_path)
            table.insert(operations, {action = "reset", file = file_path})
            return true
        end,
        open = function(file_path)
            table.insert(operations, {action = "open", file = file_path})
            return true
        end
    }
    
    return mock_fs, operations
end

-- Create test files for integration testing
function M.create_test_files()
    local files = {
        "/test/file1.txt",
        "/test/file2.txt",
        "/test/file3.txt"
    }
    
    return files
end

-- Mock user interaction
function M.mock_user_selection(choice)
    return function(items, opts, cb)
        cb(choice or "Yes")
    end
end

-- Test state transitions
function M.test_state_transition(initial_state, action, expected_state)
    -- This would test the internal state machine
    -- For now, it's a placeholder for future implementation
    assert.is_not_nil(initial_state)
    assert.is_not_nil(action)
    assert.is_not_nil(expected_state)
end

return M
