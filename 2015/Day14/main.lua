local function calculate_distance(speed, fly_time, rest_time, total_time)
    local cycle_time = fly_time + rest_time
    local full_cycles = math.floor(total_time / cycle_time)
    local remaining_time = total_time % cycle_time

    local distance = full_cycles * fly_time * speed
    if remaining_time > fly_time then
        distance = distance + fly_time * speed
    else
        distance = distance + remaining_time * speed
    end

    return distance
end

local function find_winning_reindeer(reindeer_list, total_time)
    local max_distance = 0
    local winner = nil

    for _, reindeer in ipairs(reindeer_list) do
        local distance = calculate_distance(reindeer.speed, reindeer.fly_time, reindeer.rest_time, total_time)
        if distance > max_distance then
            max_distance = distance
            winner = reindeer.name
        end
    end

    return winner, max_distance
end

local function parse_reindeer(line)
    local pattern = "(%w+) can fly (%d+) km/s for (%d+) seconds, but then must rest for (%d+) seconds."
    local name, speed, fly_time, rest_time = line:match(pattern)
    if name and speed and fly_time and rest_time then
        return {
            name = name,
            speed = tonumber(speed),
            fly_time = tonumber(fly_time),
            rest_time = tonumber(rest_time)
        }
    end
    return nil
end

local function simulate_race(reindeer_list, duration)
    local points = {}
    local distances = {}

    for _, reindeer in ipairs(reindeer_list) do
        points[reindeer.name] = 0
        distances[reindeer.name] = 0
    end

    for second = 1, duration do
        for _, reindeer in ipairs(reindeer_list) do
            if second % (reindeer.fly_time + reindeer.rest_time) <= reindeer.fly_time and second % (reindeer.fly_time + reindeer.rest_time) ~= 0 then
                distances[reindeer.name] = distances[reindeer.name] + reindeer.speed
            end
        end

        local max_distance = 0
        for _, distance in pairs(distances) do
            if distance > max_distance then
                max_distance = distance
            end
        end

        for _, reindeer in ipairs(reindeer_list) do
            if distances[reindeer.name] == max_distance then
                points[reindeer.name] = points[reindeer.name] + 1
            end
        end
    end

    return points
end

local reindeer_list = {}
for line in io.lines("input.txt") do
    local reindeer = parse_reindeer(line)
    if reindeer then
        table.insert(reindeer_list, reindeer)
    end
end

local winner, distance = find_winning_reindeer(reindeer_list, 2503)
local points = simulate_race(reindeer_list, 2503)

local race_winner = nil
local max_points = 0
for name, point in pairs(points) do
    if point > max_points then
        max_points = point
        race_winner = name
    end
end

print(string.format("Part 1: %s won with %d km", winner, distance))
print(string.format("Part 2: %s won with %d points", race_winner, max_points))
