---@param input string
---@return number
local function decompressed_length(input)
    local length = 0
    local i = 1

    while i <= #input do
        if input:sub(i, i) == '(' then
            -- Find the end of the marker
            local marker_end = input:find(')', i, true)
            if not marker_end then
                error('Invalid marker at position ' .. i)
            end

            -- Parse the marker
            local marker = input:sub(i + 1, marker_end - 1)
            local x_pos = marker:find('x', 1, true)
            if not x_pos then
                error('Invalid marker format at position ' .. i)
            end

            local chars_to_repeat = tonumber(marker:sub(1, x_pos - 1))
            local repeat_count = tonumber(marker:sub(x_pos + 1))

            -- Move the index past the marker
            i = marker_end + 1

            -- Add the length of the repeated string
            length = length + chars_to_repeat * repeat_count

            -- Move the index past the repeated string
            i = i + chars_to_repeat
        elseif not input:sub(i, i):match('%s') then
            -- Regular character, just count it
            length = length + 1
            i = i + 1
        else
            -- Skip whitespace
            i = i + 1
        end
    end

    return length
end

---@param input string
---@param start number?
---@param finish number?
---@return number
local function decompressed_length_v2(input, start, finish)
    local length = 0
    local i = start or 1
    local end_pos = finish or #input

    while i <= end_pos do
        if input:sub(i, i) == '(' then
            -- Find the end of the marker
            local marker_end = input:find(')', i, true)
            if not marker_end then
                error('Invalid marker at position ' .. i)
            end

            -- Parse the marker
            local marker = input:sub(i + 1, marker_end - 1)
            local x_pos = marker:find('x', 1, true)
            if not x_pos then
                error('Invalid marker format at position ' .. i)
            end

            local chars_to_repeat = tonumber(marker:sub(1, x_pos - 1))
            local repeat_count = tonumber(marker:sub(x_pos + 1))

            -- Move the index past the marker
            i = marker_end + 1

            -- Recursively calculate the length of the repeated string
            local repeated_length = decompressed_length_v2(input, i, i + chars_to_repeat - 1)
            length = length + repeated_length * repeat_count

            -- Move the index past the repeated string
            i = i + chars_to_repeat
        elseif not input:sub(i, i):match('%s') then
            -- Regular character, just count it
            length = length + 1
            i = i + 1
        else
            -- Skip whitespace
            i = i + 1
        end
    end

    return length
end

local file = io.open('input.txt', 'r')
if not file then
    error('Failed to open input file')
end

local input = file:read('*all')
file:close()

print('Part 1: ' .. decompressed_length(input))
print('Part 2: ' .. decompressed_length_v2(input))
