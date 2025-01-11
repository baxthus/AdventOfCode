local function calculate_matchsticks(line)
    local unquoted = line:sub(2, #line - 1)

    local memoryCount = 0
    local i = 1
    while i <= #unquoted do
        if unquoted:sub(i, i) == '\\' then
            if unquoted:sub(i + 1, i + 1) == 'x' then
                i = i + 4
            else
                i = i + 2
            end
        else
            i = i + 1
        end
        memoryCount = memoryCount + 1
    end

    return #line - memoryCount
end

local function calculate_matchsticks2(line)
    local encoded = '"'
    for i = 1, #line do
        local char = line:sub(i, i)
        if char == '\\' then
            encoded = encoded .. '\\\\'
        elseif char == '"' then
            encoded = encoded .. '\\"'
        else
            encoded = encoded .. char
        end
    end
    encoded = encoded .. '"'

    return #encoded - #line
end

local lines = {}
for line in io.lines('input.txt') do
    table.insert(lines, line)
end

local part1 = 0
local part2 = 0

for _, line in ipairs(lines) do
    part1 = part1 + calculate_matchsticks(line)
    part2 = part2 + calculate_matchsticks2(line)
end

print('Part 1: ' .. part1)
print('Part 2: ' .. part2)
