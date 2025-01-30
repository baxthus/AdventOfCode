local Room = {}
Room.__index = Room

function Room:new(name, sector_id, checksum)
    local room = setmetatable({}, Room)
    room.name = name
    room.sector_id = sector_id
    room.checksum = checksum
    return room
end

local function parse_input(filename)
    local rooms = {}
    for line in io.lines(filename) do
        local last_dash = line:match('^.*()-')
        local bracket_start = line:find('%[')
        local bracket_end = line:find('%]')

        local name = line:sub(1, last_dash - 1)
        local sector_id = tonumber(line:sub(last_dash + 1, bracket_start - 1))
        local checksum = line:sub(bracket_start + 1, bracket_end - 1)

        table.insert(rooms, Room:new(name, sector_id, checksum))
    end
    return rooms
end

local function calculate_checksum(name)
    local frequency = {}

    for c in name:gmatch('.') do
        if c ~= '-' then
            frequency[c] = (frequency[c] or 0) + 1
        end
    end

    local freq_list = {}
    for k, v in pairs(frequency) do
        table.insert(freq_list, {key = k, value = v})
    end

    table.sort(freq_list, function (a, b)
        if a.value == b.value then
            return a.key < b.key
        end
        return a.value > b.value
    end)

    local checksum = ''
    for i = 1, 5 do
        checksum = checksum .. freq_list[i].key
    end

    return checksum
end

local function decrypt_name(name, sector_id)
    local decrypted_name = {}
    for c in name:gmatch('.') do
        if c == '-' then
            table.insert(decrypted_name, ' ')
        else
            local new_char = string.char(((string.byte(c) - string.byte('a') + sector_id) % 26) + string.byte('a'))
            table.insert(decrypted_name, new_char)
        end
    end
    return table.concat(decrypted_name)
end

local rooms = parse_input('input.txt')
local sum_of_sector_ids = 0
local north_pole_sector_id = -1

for _, room in ipairs(rooms) do
    local checksum = calculate_checksum(room.name)
    if checksum == room.checksum then
        sum_of_sector_ids = sum_of_sector_ids + room.sector_id
        local decrypted_name = decrypt_name(room.name, room.sector_id)
        if decrypted_name:find('northpole') then
            north_pole_sector_id = room.sector_id
        end
    end
end

print('Part 1: ' .. sum_of_sector_ids)
print('Part 2: ' .. north_pole_sector_id)
