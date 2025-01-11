local function parse_input(filename)
    local distances = {}
    local cities = {}
    for line in io.lines(filename) do
        local route, distance = line:match("(.+) = (%d+)")
        if route and distance then
            distance = tonumber(distance)
            local city1, city2 = route:match("(.+) to (.+)")
            distances[city1 .. "-" .. city2] = distance
            distances[city2 .. "-" .. city1] = distance
            cities[city1] = true
            cities[city2] = true
        end
    end
    return distances, cities
end

local function calculate_route_distance(route, distances)
    local total_distance = 0
    for i = 1, #route - 1 do
        total_distance = total_distance + distances[route[i] .. "-" .. route[i + 1]]
    end
    return total_distance
end

local function find_shortest_route(distances, cities, permutations)
    local shortest_distance = math.huge
    for _, route in ipairs(permutations) do
        local distance = calculate_route_distance(route, distances)
        if distance < shortest_distance then
            shortest_distance = distance
        end
    end
    return shortest_distance
end

local function find_longest_route(distances, cities, permutations)
    local longest_distance = 0
    for _, route in ipairs(permutations) do
        local distance = calculate_route_distance(route, distances)
        if distance > longest_distance then
            longest_distance = distance
        end
    end
    return longest_distance
end

local function permute(items)
    if #items == 1 then
        return { items }
    end

    local perms = {}
    for i = 1, #items do
        local current = items[i]
        local remaining = { table.unpack(items) }
        table.remove(remaining, i)
        for _, perm in ipairs(permute(remaining)) do
            table.insert(perms, { current, table.unpack(perm) })
        end
    end
    return perms
end

local distances, cities = parse_input("input.txt")
local city_list = {}
for city in pairs(cities) do
    table.insert(city_list, city)
end
local permutations = permute(city_list)

print("Part 1: " .. find_shortest_route(distances, cities, permutations))
print("Part 2: " .. find_longest_route(distances, cities, permutations))
