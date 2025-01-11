local function contains_invalid_characters(password)
    return password:find('i') or password:find('o') or password:find('l')
end

local function has_straight(password)
    for i = 1, #password - 2 do
        if password:byte(i) + 1 == password:byte(i + 1) and password:byte(i) + 2 == password:byte(i + 2) then
            return true
        end
    end
    return false
end

local function has_two_pairs(password)
    local pairs = 0
    local i = 1
    while i < #password do
        if password:sub(i, i) == password:sub(i + 1, i + 1) then
            pairs = pairs + 1
            i = i + 2
        else
            i = i + 1
        end
    end
    return pairs >= 2
end

local function increment_password(password)
    local code_units = { password:byte(1, #password) }
    for i = #code_units, 1, -1 do
        if code_units[i] == string.byte('z') then
            code_units[i] = string.byte('a')
        else
            code_units[i] = code_units[i] + 1
            break
        end
    end
    return string.char(table.unpack(code_units))
end

local function find_next_password(password)
    repeat
        password = increment_password(password)
    until not contains_invalid_characters(password) and has_straight(password) and has_two_pairs(password)
    return password
end

local input = 'hxbxwxba'
local password = find_next_password(input)
print('Part 1: ' .. password)
print('Part 2: ' .. find_next_password(password))
