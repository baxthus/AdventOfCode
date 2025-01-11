function string:trim()
    ---@diagnostic disable-next-line: param-type-mismatch
    return self:match('^%s*(.-)%s*$')
end

local function parse_input(filename)
    local aunts = {}

    for line in io.lines(filename) do
        local sue_member, attributes = line:match('Sue (%d+): (.+)')
        if sue_member and attributes then
            sue_member = tonumber(sue_member)
            local aunt_data = {}
            for attribute in attributes:gmatch('[^,]+') do
                local key, value = attribute:match('([^:]+): (%d+)')
                if key and value then
                    aunt_data[key:trim()] = tonumber(value)
                end
            end
            if not sue_member then
                error('Failed to parse line: ' .. line)
            end
            aunts[sue_member] = aunt_data
        end
    end

    return aunts
end

local function find_matching_sue(aunts, mfcsam_reading)
    for sue, attributes in pairs(aunts) do
        local match = true
        for key, value in pairs(attributes) do
            if mfcsam_reading[key] ~= value then
                match = false
                break
            end
        end
        if match then
            return sue
        end
    end
    return "No match found"
end

local function match_attribute(attr, value, mfcsam_value)
    if attr == 'cats' or attr == 'trees' then
        return mfcsam_value and value > mfcsam_value
    elseif attr == 'pomeranians' or attr == 'goldfish' then
        return mfcsam_value and value < mfcsam_value
    else
        return mfcsam_value and value == mfcsam_value
    end
end

local function find_real_sue(aunts, mfcsam_reading)
    for sue, attributes in pairs(aunts) do
        local match = true
        for key, value in pairs(attributes) do
            if not match_attribute(key, value, mfcsam_reading[key]) then
                match = false
                break
            end
        end
        if match then
            return sue
        end
    end
    return "No match found"
end

local mfcsam_reading = {
    children = 3,
    cats = 7,
    samoyeds = 2,
    pomeranians = 3,
    akitas = 0,
    vizslas = 0,
    goldfish = 5,
    trees = 3,
    cars = 2,
    perfumes = 1
}

local aunts = parse_input('input.txt')

print('Part 1: ' .. find_matching_sue(aunts, mfcsam_reading))
print('Part 2: ' .. find_real_sue(aunts, mfcsam_reading))
