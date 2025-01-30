local function decode_message(messages, find_least_frequent)
    if #messages == 0 then return '' end

    local num_columns = #messages[1]
    local frequency_maps = {}

    for i = 1, num_columns do
        frequency_maps[i] = {}
    end

    for _, message in ipairs(messages) do
        for i = 1, num_columns do
            local char = message:sub(i, i)
            frequency_maps[i][char] = (frequency_maps[i][char] or 0) + 1
        end
    end

    local decoded_message = ''
    for i = 1, num_columns do
        local frequency_map = frequency_maps[i]
        local selected_char = ' '
        local selected_frequency = find_least_frequent and math.huge or 0

        for char, frequency in pairs(frequency_map) do
            if find_least_frequent and frequency < selected_frequency or
               not find_least_frequent and frequency > selected_frequency then
                selected_char = char
                selected_frequency = frequency
            end
        end

        decoded_message = decoded_message .. selected_char
    end

    return decoded_message
end

local messages = {}
for line in io.lines('input.txt') do
    table.insert(messages, line)
end

print('Part 1: ' .. decode_message(messages, false))
print('Part 2: ' .. decode_message(messages, true))
