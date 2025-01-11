local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function calculate_wrapping_paper(dimensions)
    local parts = split(dimensions, 'x')
    local l = tonumber(parts[1])
    local w = tonumber(parts[2])
    local h = tonumber(parts[3])

    local surface_area = 2*l*w + 2*w*h + 2*h*l
    local smallest_side = math.min(l*w, w*h, h*l)
    return surface_area + smallest_side
end

local function total_wrapping_paper(lines)
    local total = 0
    for _, line in ipairs(lines) do
        total = total + calculate_wrapping_paper(line)
    end
    return total
end

local function calculate_ribbon(dimensions)
    local parts = split(dimensions, 'x')
    local l = tonumber(parts[1])
    local w = tonumber(parts[2])
    local h = tonumber(parts[3])

    local volume = l*w*h
    local smallest_perimeter = math.min(2*l+2*w, 2*w+2*h, 2*h+2*l)
    return volume + smallest_perimeter
end

local function total_ribbon(lines)
    local total = 0
    for _, line in ipairs(lines) do
        total = total + calculate_ribbon(line)
    end
    return total
end

local function read_lines(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    return lines
end

local lines = read_lines('input.txt')
print('Part 1: ' .. total_wrapping_paper(lines))
print('Part 2: ' .. total_ribbon(lines))
