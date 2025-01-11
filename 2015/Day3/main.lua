local function Pair(first, second)
    return { first = first, second = second }
end

local function pair_equals(p1, p2)
    return p1.first == p2.first and p1.second == p2.second
end

local function pair_hash(pair)
    return tostring(pair.first) .. ',' .. tostring(pair.second)
end

local function count_houses_with_presents(directions)
    local x, y = 0, 0
    local visited = {}
    visited[pair_hash(Pair(x, y))] = true

    for i = 1, #directions do
        local direction = directions:sub(i, i)
        if direction == '^' then
            y = y + 1
        elseif direction == 'v' then
            y = y - 1
        elseif direction == '>' then
            x = x + 1
        elseif direction == '<' then
            x = x - 1
        end
        visited[pair_hash(Pair(x, y))] = true
    end

    local count = 0
    for _ in pairs(visited) do
        count = count + 1
    end

    return count
end

local function count_houses_with_presents2(directions)
    local santa_x, santa_y = 0, 0
    local robot_x, robot_y = 0, 0
    local visited = {}
    visited[pair_hash(Pair(0, 0))] = true

    for i = 1, #directions do
        local x, y
        if i % 2 == 1 then
            x, y = santa_x, santa_y
        else
            x, y = robot_x, robot_y
        end

        local direction = directions:sub(i, i)
        if direction == '^' then
            y = y + 1
        elseif direction == 'v' then
            y = y - 1
        elseif direction == '>' then
            x = x + 1
        elseif direction == '<' then
            x = x - 1
        end

        if i % 2 == 1 then
            santa_x, santa_y = x, y
        else
            robot_x, robot_y = x, y
        end

        visited[pair_hash(Pair(x, y))] = true
    end

    local count = 0
    for _ in pairs(visited) do
        count = count + 1
    end

    return count
end

local file, err = io.open('input.txt', 'r')
if not file then
    print('Could not open file: ' .. err)
    os.exit(1)
end

local directions = file:read('*a')

print('Part 1: ' .. count_houses_with_presents(directions))
print('Part 2: ' .. count_houses_with_presents2(directions))
