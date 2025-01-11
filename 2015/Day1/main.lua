local function calculate_final_floor(instructions)
    local floor = 0
    for i = 1, #instructions do
        local c = instructions:sub(i, i)
        if c == '('  then
            floor = floor + 1
        elseif c == ')' then
            floor = floor - 1
        end
    end
    return floor
end

local function find_basement_entry(instructions)
    local floor = 0
    for position = 1, #instructions do
        local c = instructions:sub(position, position)
        if c == '(' then
            floor = floor + 1
        elseif c == ')' then
            floor = floor - 1
        end

        if floor == -1 then
            return position
        end
    end
    return -1
end

local file, err = io.open('input.txt', 'r')
if not file then
    print('Could not open file: ' .. err)
    os.exit(1)
end

local instructions = file:read('*all')
file:close()

print('Part 1: ' .. calculate_final_floor(instructions))
print('Part 2: ' .. find_basement_entry(instructions))
