local function look_and_say(input)
    local result = {}
    local count = 1

    for i = 2, #input + 1 do
        if i <= #input and input:sub(i, i) == input:sub(i - 1, i - 1) then
            count = count + 1
        else
            table.insert(result, tostring(count) .. input:sub(i - 1, i - 1))
            count = 1
        end
    end

    return table.concat(result)
end

local input = '3113322113'

for i = 1, 40 do
    input = look_and_say(input)
end
print('Part 1:', #input)

for i = 1, 10 do
    input = look_and_say(input)
end
print('Part 2:', #input)
