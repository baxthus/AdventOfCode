local function find_lowest_house(target_presents)
    local max_houses = math.ceil(target_presents / 10)
    local house_presents = {}
    for i = 1, max_houses + 1 do
        house_presents[i] = 0
    end

    for elf = 1, #house_presents do
        for house = elf, #house_presents, elf do
            house_presents[house] = house_presents[house] + elf * 10
        end
    end

    for house_number = 1, #house_presents do
        if house_presents[house_number] >= target_presents then
            return house_number
        end
    end

    return -1 -- No house found
end

local function find_lowest_house2(target_presents)
    local max_houses = math.ceil(target_presents / 11)
    local house_presents = {}
    for i = 1, max_houses + 1 do
        house_presents[i] = 0
    end

    for elf = 1, #house_presents do
        for house = elf, math.min(50 * elf, #house_presents), elf do
            house_presents[house] = house_presents[house] + elf * 11
        end
    end

    for house_number = 1, #house_presents do
        if house_presents[house_number] >= target_presents then
            return house_number
        end
    end

    return -1 -- No house found
end

local input = 34000000

print('Part 1: ' .. find_lowest_house(input))
print('Part 2: ' .. find_lowest_house2(input))
