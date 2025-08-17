local M = {}

local default_floating = -1
local state = {
    count = 0,
    floating = default_floating,
}

local function reset_state()
    state.count = 0
    state.floating = default_floating
end

local function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

local function close_popup()
    if state.floating ~= default_floating and vim.api.nvim_win_is_valid(state.floating) then
        vim.api.nvim_win_close(state.floating, true)
        reset_state()
    end
end

local function get_file_path()
    local popup_buf = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_number = cursor_pos[1]
    local file_path = vim.api.nvim_buf_get_lines(popup_buf, line_number - 1, line_number, false)[1]

    return file_path
end

local function check_buf(file_path)
    if not file_path or file_path == "" then
        return -1
    end

    local buf_id = vim.fn.bufnr(file_path)
    if buf_id == -1 then
        vim.notify("Buffer not found for file: " .. file_path, vim.log.levels.WARN)
        return -1
    end
    return buf_id
end

local function save_selected_file()
    local file_path = get_file_path()
    local buf_id = check_buf(file_path)

    if buf_id == -1 then
        return
    end

    if vim.api.nvim_buf_get_option(buf_id, "modified") then
        vim.api.nvim_buf_call(buf_id, function()
            vim.cmd("write")
        end)
        state.count = math.max(state.count - 1, 0)
        vim.notify("Saved: " .. file_path, vim.log.levels.INFO)
    else
        vim.notify("File is not modified: " .. file_path, vim.log.levels.INFO)
    end
end

local function open_selected_file()
    local file_path = get_file_path()
    local buf_id = check_buf(file_path)

    if buf_id == -1 then
        return
    end

    if vim.api.nvim_buf_get_option(buf_id, "modified") then
        vim.api.nvim_command("tabnew") -- Open a new tab
        vim.api.nvim_set_current_buf(buf_id)
    else
        vim.notify("File is not modified: " .. file_path, vim.log.levels.INFO)
    end
end

local function reset_changes()
    local file_path = get_file_path()
    local buf_id = check_buf(file_path)

    if buf_id == -1 then
        return
    end

    if vim.api.nvim_buf_get_option(buf_id, "modified") then
        vim.api.nvim_buf_call(buf_id, function()
            vim.cmd("e!")
        end)
        state.count = math.max(state.count - 1, 0)
        vim.notify("Reset: " .. file_path, vim.log.levels.INFO)
    else
        vim.notify("File is not modified: " .. file_path, vim.log.levels.INFO)
    end
end

local function restar()
    -- Always refresh the popup to show current state
    vim.schedule(parse_files)
end

local function save_restart()
    save_selected_file()
    restar()
end

local function reset_restart()
    reset_changes()
    restar()
end

local function show_file_popup(files)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, files)

    local width, height = 50, math.min(#files + 2, 20)
    local win_width, win_height = vim.o.columns, vim.o.lines
    local col, row = math.floor((win_width - width) / 2), math.floor((win_height - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    state.floating = win

    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "s", save_restart, { buffer = buf, noremap = true, silent = true })
    vim.keymap.set("n", "x", reset_restart, { buffer = buf, noremap = true, silent = true })
    vim.keymap.set("n", "<CR>", open_selected_file, { buffer = buf, noremap = true, silent = true })

    vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        callback = close_popup,
    })
end

---@diagnostic disable-next-line: lowercase-global
function parse_files()
    local root_path = vim.loop.cwd() or ""
    local escaped_root = escape_pattern(root_path)
    local changed_files = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, "modified") then
            local file = vim.api.nvim_buf_get_name(buf)
            if file ~= "" then
                local relativeFilePath = file:gsub("^" .. escaped_root .. "/", "", 1)
                table.insert(changed_files, relativeFilePath)
            end
        end
    end

    state.count = #changed_files
    if #changed_files > 0 then
        -- If popup is already open, update it; otherwise create new one
        if state.floating ~= default_floating and vim.api.nvim_win_is_valid(state.floating) then
            -- Update existing popup
            local buf = vim.api.nvim_win_get_buf(state.floating)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, changed_files)
        else
            -- Create new popup
            show_file_popup(changed_files)
        end
    else
        -- No more unsaved files, close popup if it's open
        if state.floating ~= default_floating and vim.api.nvim_win_is_valid(state.floating) then
            close_popup()
        end
        vim.notify("No unsaved files found.", vim.log.levels.INFO)
    end
end

function M.has_missed_files(cb)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, "modified") then
            vim.ui.select({ "Yes", "No" }, {
                prompt = "You have unsaved changes. Do you want to proceed?",
            }, function(choice)
                if choice == nil then
                    choice = "No"
                end

                if choice == "Yes" and cb then
                    cb()
                else
                    print("Cancelled.")
                end
            end)
            return
        end
    end

    if cb then
        cb()
    end
end

M.setup = function()
    vim.keymap.set("n", "<leader>a", parse_files)
end

return M
