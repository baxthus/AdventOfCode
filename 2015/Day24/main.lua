local function read_input(filename)
    local weights = {}
    for line in io.lines(filename) do
        table.insert(weights, tonumber(line))
    end
    return weights
end

local function calculate_quantum_entanglement(group)
    local product = 1
    for _, weight in ipairs(group) do
        product = product * weight
    end
    return product
end

local function find_combinations(weights, target_weight, group_size, combination, start, current_sum)
    if #combination == group_size then
        return current_sum == target_weight
    end
    for i = start, #weights do
        table.insert(combination, weights[i])
        if find_combinations(weights, target_weight, group_size, combination, i + 1, current_sum + weights[i]) then
            return true
        end
        table.remove(combination)
    end
    return false
end

local function find_ideal_quantum_entanglement(weights, num_groups)
    local total_weight = 0
    for _, weight in ipairs(weights) do
        total_weight = total_weight + weight
    end
    local target_weight = total_weight / num_groups
    local n = #weights

    local minQE = math.huge

    for group_size = 1, math.floor(n / num_groups) do
        local combination = {}
        if find_combinations(weights, target_weight, group_size, combination, 1, 0) then
            local qe = calculate_quantum_entanglement(combination)
            if qe < minQE then
                minQE = qe
            end
        end
        if minQE ~= math.huge then
            break
        end
    end

    return minQE
end

local weights = read_input('input.txt')
print('Part 1: ' .. find_ideal_quantum_entanglement(weights, 3))
print('Part 2: ' .. find_ideal_quantum_entanglement(weights, 4))
