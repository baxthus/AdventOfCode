local wire_values = {}
local instructions = {}

local function get_wire_value(wire)
    if wire_values[wire] then
        return wire_values[wire]
    end
    if tonumber(wire) then
        return tonumber(wire)
    end

    local instruction = instructions[wire]
    local result

    if #instruction == 1 then
        result = get_wire_value(instruction[1])
    elseif #instruction == 2 then
        result = ~get_wire_value(instruction[2])
    else
        local left = get_wire_value(instruction[1])
        local right = get_wire_value(instruction[3])
        local op = instruction[2]

        if op == "AND" then
            result = left & right
        elseif op == "OR" then
            result = left | right
        elseif op == "LSHIFT" then
            result = left << right
        elseif op == "RSHIFT" then
            result = left >> right
        else
            error("Unknown operator: " .. op)
        end
    end

    wire_values[wire] = result
    return result
end

local function solve_circuit(override_b, b_value)
    wire_values = {}
    if override_b then
        wire_values["b"] = b_value
    end
    return get_wire_value("a")
end

for line in io.lines('input.txt') do
    local tokens = {}
    for token in string.gmatch(line, "%S+") do
        if token ~= "->" then
            table.insert(tokens, token)
        end
    end
    local wire = table.remove(tokens)
    instructions[wire] = tokens
end

local part1 = get_wire_value("a")
print("Part 1: " .. part1)
print("Part 2: " .. solve_circuit(true, part1))
