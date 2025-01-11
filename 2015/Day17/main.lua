local function combinations(elements, r)
    if r == 0 then
        coroutine.yield({})
    else
        for i = 1, #elements - r + 1 do
            local remaining = { table.unpack(elements, i + 1) }
            for combo in coroutine.wrap(function() combinations(remaining, r - 1) end) do
                table.insert(combo, 1, elements[i])
                coroutine.yield(combo)
            end
        end
    end
end

local function count_eggnog_combinations(containers, target)
    local count = 0
    for r = 1, #containers do
        for combo in coroutine.wrap(function() combinations(containers, r) end) do
            local sum = 0
            for _, v in ipairs(combo) do
                sum = sum + v
            end
            if sum == target then
                count = count + 1
            end
        end
    end
    return count
end

local function find_min_containers_and_combinations(containers, target)
    for r = 1, #containers do
        local count = 0
        for combo in coroutine.wrap(function() combinations(containers, r) end) do
            local sum = 0
            for _, v in ipairs(combo) do
                sum = sum + v
            end
            if sum == target then
                count = count + 1
            end
        end
        if count > 0 then
            return { min_containers = r, combinations = count }
        end
    end
    return { min_containers = 0, combinations = 0 }
end

local function read_input(filename)
    local containers = {}
    for line in io.lines(filename) do
        table.insert(containers, tonumber(line))
    end
    return containers
end


local containers = read_input('input.txt')
local target_volume = 150

print('Part 1: ' .. count_eggnog_combinations(containers, target_volume))
local result = find_min_containers_and_combinations(containers, target_volume)
print('Part 2: ' .. result.combinations)
