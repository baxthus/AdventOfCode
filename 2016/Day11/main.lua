local function create_state(elevator, items, steps)
    return {
        elevator = elevator,
        items = items,
        steps = steps,

        get_hash = function (self)
            local hash = tostring(self.elevator) .. '-'

            -- Create a copy of items to sort
            local sorted_items = {}
            for i, item in ipairs(self.items) do
                sorted_items[i] = {item[1], item[2]}
            end

            -- Sort the items array
            table.sort(sorted_items, function (a, b)
                if a[1] == b[1] then
                    return a[2] < b[2]
                end
                return a[1] < b[1]
            end)

            for _, item in ipairs(sorted_items) do
                hash = hash .. tostring(item[1]) .. ',' .. tostring(item[2]) .. ';'
            end

            return hash
        end,

        is_valid = function (self)
            for i, item in ipairs(self.items) do
                local chip_floor = item[2]

                -- If generator and chip are on the same floor, the chip is safe
                if chip_floor == item[1] then
                    goto continue
                end

                -- Check if any other generator is on the same floor as this chip
                for j, otherItem in ipairs(self.items) do
                    if j ~= i and otherItem[1] == chip_floor then
                        return false
                    end
                end

                ::continue::
            end

            return true
        end,

        is_goal = function (self)
            for _, item in ipairs(self.items) do
                if item[1] ~= 4 or item[2] ~= 4 then
                    return false
                end
            end
            return true
        end
    }
end

local function get_next_states(current)
    local next_states = {}
    local possible_floors = {}

    if current.elevator < 4 then
        table.insert(possible_floors, current.elevator + 1)
    end
    if current.elevator > 1 then
        table.insert(possible_floors, current.elevator - 1)
    end

    local items_on_floor = {} -- {index,  type} where type: 1=gen, 2=chip
    for i, item in ipairs(current.items) do
        if item[1] == current.elevator then
            table.insert(items_on_floor, {i ,1})
        end
        if item[2] == current.elevator then
            table.insert(items_on_floor, {i ,2})
        end
    end

    for _, item1 in ipairs(items_on_floor) do
        -- Try moving one item
        for _, next_floor in ipairs(possible_floors) do
            local new_state = create_state(next_floor, {}, current.steps + 1)

            -- Copy items
            for i, item in ipairs(current.items) do
                new_state.items[i] = {item[1], item[2]}
            end

            -- Upddate the moved item
            if item1[2] == 1 then
                new_state.items[item1[1]][1] = next_floor
            else
                new_state.items[item1[1]][2] = next_floor
            end

            if new_state:is_valid() then
                table.insert(next_states, new_state)
            end
        end

        -- Try moving two items
        for _, item2 in ipairs(items_on_floor) do
            if item1[1] == item2[1] and item1[2] == item2[2] then
                goto continue
            end

            for _, next_floor in ipairs(possible_floors) do
                local new_state = create_state(next_floor, {}, current.steps + 1)

                -- Copy items
                for i, item in ipairs(current.items) do
                    new_state.items[i] = {item[1], item[2]}
                end

                -- Upddate the moved item
                if item1[2] == 1 then
                    new_state.items[item1[1]][1] = next_floor
                else
                    new_state.items[item1[1]][2] = next_floor
                end

                if item2[2] == 1 then
                    new_state.items[item2[1]][1] = next_floor
                else
                    new_state.items[item2[1]][2] = next_floor
                end

                if new_state:is_valid() then
                    table.insert(next_states, new_state)
                end
            end

            ::continue::
        end
    end

    return next_states
end


local function parse_input(input, part2)
    local element_index = {}
    local items = {} -- {generator_floor, chip_floor}

    for floor = 1, #input do
        local line = input[floor]

        -- Find generators
        for element in string.gmatch(line, '(%w+) generator') do
            if not element_index[element] then
                element_index[element] = #items + 1
                items[element_index[element]] = {floor, 0}
            else
                items[element_index[element]][1] = floor
            end
        end

        -- Find microchips
        for element in string.gmatch(line, '(%w+)-compatible microchip') do
            if not element_index[element] then
                element_index[element] = #items + 1
                items[element_index[element]] = {0, floor}
            else
                items[element_index[element]][2] = floor
            end
        end
    end

    if part2 then
        table.insert(items, {1, 1}) -- Elerium generator and microchip
        table.insert(items, {1, 1}) -- Dilithium generator and microchip
    end

    return create_state(1, items, 0)
end

local function find_minimum_steps(initial_state)
    local queue = {initial_state}
    local visited = {}
    visited[initial_state:get_hash()] = true

    local front = 1
    while front <= #queue do
        local current = queue[front]
        front = front + 1

        if current:is_goal() then
            return current.steps
        end

        for _, next_state in ipairs(get_next_states(current)) do
            local hash = next_state:get_hash()
            if not visited[hash] then
                visited[hash] = true
                table.insert(queue, next_state)
            end
        end
    end

    return -1
end

local input = {}
for line in io.lines('input.txt') do
    table.insert(input, line)
end

local initial_state = parse_input(input)
print('Minimum steps: ' .. find_minimum_steps(initial_state))

local initial_state2 = parse_input(input, true)
print('Minimum steps with additional items: ' .. find_minimum_steps(initial_state2))
