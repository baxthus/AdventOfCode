local function read_file(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    return lines
end

local keypad = {
    ['1'] = { 0, 2 },
    ['2'] = { 1, 1 },
    ['3'] = { 1, 2 },
    ['4'] = { 1, 3 },
    ['5'] = { 2, 0 },
    ['6'] = { 2, 1 },
    ['7'] = { 2, 2 },
    ['8'] = { 2, 3 },
    ['9'] = { 2, 4 },
    ['A'] = { 3, 1 },
    ['B'] = { 3, 2 },
    ['C'] = { 3, 3 },
    ['D'] = { 4, 2 }
}

local instructions = read_file('input.txt')

local reversed_keypad = {}
for k, v in pairs(keypad) do
    if not reversed_keypad[v[1]] then
        reversed_keypad[v[1]] = {}
    end
    reversed_keypad[v[1]][v[2]] = k
end

local x1, y1 = 1, 1 -- Part 1
local x2, y2 = 2, 0 -- Part 2

local code = ''
local code2 = ''

for _, instruction in ipairs(instructions) do
    for move in instruction:gmatch('.') do
        local new_x2, new_y2 = x2, y2
        if move == 'U' then
            if y1 > 0 then y1 = y1 - 1 end
            new_x2 = x2 - 1
        elseif move == 'D' then
            if y1 < 2 then y1 = y1 + 1 end
            new_x2 = x2 + 1
        elseif move == 'L' then
            if x1 > 0 then x1 = x1 - 1 end
            new_y2 = y2 - 1
        elseif move == 'R' then
            if x1 < 2 then x1 = x1 + 1 end
            new_y2 = y2 + 1
        end
        if reversed_keypad[new_x2] and reversed_keypad[new_x2][new_y2] then
            x2, y2 = new_x2, new_y2
        end
    end
    code = code .. tostring(y1 * 3 + x1 + 1)
    code2 = code2 .. reversed_keypad[x2][y2]
end

print('Part 1: ' .. code)
print('Part 2: ' .. code2)
