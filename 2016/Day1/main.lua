local Direction = { North = 1, East = 2, South = 3, West = 4 }

local Position = {}
Position.__index = Position

function Position:new(x, y)
    local pos = setmetatable({}, Position)
    pos.x = x
    pos.y = y
    return pos
end

function Position:__eq(other)
    return self.x == other.x and self.y == other.y
end

function Position:hash()
    return tostring(self.x) .. ',' .. tostring(self.y)
end

local instructions = {}
for line in io.lines('input.txt') do
    for instr in string.gmatch(line, '([^,]+)') do
        table.insert(instructions, instr:match('%s*(.-)%s*$'))
    end
end

local pos = Position:new(0, 0)
local dir = Direction.North
local visited = {}
visited[pos:hash()] = true
local found = false
local first_revisited_distance = 0

for _, instr in ipairs(instructions) do
    local turn = instr:sub(1, 1)
    local steps = tonumber(instr:sub(2))

    if turn == 'L' then
        dir = (dir - 2) % 4 + 1 -- Left
    else
        dir = dir % 4 + 1       -- Right
    end

    for i = 1, steps do
        if dir == Direction.North then
            pos = Position:new(pos.x, pos.y + 1)
        elseif dir == Direction.East then
            pos = Position:new(pos.x + 1, pos.y)
        elseif dir == Direction.South then
            pos = Position:new(pos.x, pos.y - 1)
        elseif dir == Direction.West then
            pos = Position:new(pos.x - 1, pos.y)
        end

        local pos_hash = pos:hash()
        if visited[pos_hash] and not found then
            first_revisited_distance = math.abs(pos.x) + math.abs(pos.y)
            found = true
        end
        visited[pos_hash] = true
    end
end

print('Part 1: ' .. math.abs(pos.x) + math.abs(pos.y))
if found then
    print('Part 2: ' .. first_revisited_distance)
else
    print('Part 2: Not found')
end
