local function process_lights(instructions)
    local grid = {}
    for i = 1, 1000 do
        grid[i] = {}
        for j = 1, 1000 do
            grid[i][j] = false
        end
    end

    for _, instruction in ipairs(instructions) do
        local parts = {}
        for part in instruction:gmatch("%S+") do
            table.insert(parts, part)
        end

        if parts[1] == "turn" then
            local action = parts[2]
            local start = { parts[3]:match("(%d+),(%d+)") }
            local end_ = { parts[5]:match("(%d+),(%d+)") }
            for i = tonumber(start[1]), tonumber(end_[1]) do
                for j = tonumber(start[2]), tonumber(end_[2]) do
                    grid[i + 1][j + 1] = action == "on"
                end
            end
        elseif parts[1] == "toggle" then
            local start = { parts[2]:match("(%d+),(%d+)") }
            local end_ = { parts[4]:match("(%d+),(%d+)") }
            for i = tonumber(start[1]), tonumber(end_[1]) do
                for j = tonumber(start[2]), tonumber(end_[2]) do
                    grid[i + 1][j + 1] = not grid[i + 1][j + 1]
                end
            end
        end
    end

    local count = 0
    for i = 1, 1000 do
        for j = 1, 1000 do
            if grid[i][j] then
                count = count + 1
            end
        end
    end

    return count
end

local function process_light_brightness(instructions)
    local grid = {}
    for i = 1, 1000 do
        grid[i] = {}
        for j = 1, 1000 do
            grid[i][j] = 0
        end
    end

    for _, instruction in ipairs(instructions) do
        local parts = {}
        for part in instruction:gmatch("%S+") do
            table.insert(parts, part)
        end

        if parts[1] == "turn" then
            local action = parts[2]
            local start = { parts[3]:match("(%d+),(%d+)") }
            local end_ = { parts[5]:match("(%d+),(%d+)") }
            for i = tonumber(start[1]), tonumber(end_[1]) do
                for j = tonumber(start[2]), tonumber(end_[2]) do
                    if action == "on" then
                        grid[i + 1][j + 1] = grid[i + 1][j + 1] + 1
                    elseif action == "off" then
                        grid[i + 1][j + 1] = math.max(0, grid[i + 1][j + 1] - 1)
                    end
                end
            end
        elseif parts[1] == "toggle" then
            local start = { parts[2]:match("(%d+),(%d+)") }
            local end_ = { parts[4]:match("(%d+),(%d+)") }
            for i = tonumber(start[1]), tonumber(end_[1]) do
                for j = tonumber(start[2]), tonumber(end_[2]) do
                    grid[i + 1][j + 1] = grid[i + 1][j + 1] + 2
                end
            end
        end
    end

    local total_brightness = 0
    for i = 1, 1000 do
        for j = 1, 1000 do
            total_brightness = total_brightness + grid[i][j]
        end
    end

    return total_brightness
end

local instructions = {}
for line in io.lines('input.txt') do
    table.insert(instructions, line)
end

print('Part 1: ' .. process_lights(instructions))
print('Part 2: ' .. process_light_brightness(instructions))
