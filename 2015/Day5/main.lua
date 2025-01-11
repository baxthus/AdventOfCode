local function is_nice_string(s)
    local vowels = "aeiou"
    local disallowed = { "ab", "cd", "pq", "xy" }
    local vowel_count = 0
    local has_double_letter = false
    local contains_disallowed = false

    for i = 1, #s do
        local char = s:sub(i, i)
        if vowels:find(char) then
            vowel_count = vowel_count + 1
        end
        if i > 1 and s:sub(i, i) == s:sub(i - 1, i - 1) then
            has_double_letter = true
        end
    end

    for _, dis in ipairs(disallowed) do
        if s:find(dis) then
            contains_disallowed = true
            break
        end
    end

    return vowel_count >= 3 and has_double_letter and not contains_disallowed
end

local function is_nice_string2(s)
    local repeating_pair = s:match("(..).*%1")
    local repeating_letter_with_one_between = s:match("(.).%1")
    return repeating_pair and repeating_letter_with_one_between
end

local function count_nice_strings(strings, func)
    local count = 0
    for _, s in ipairs(strings) do
        if func(s) then
            count = count + 1
        end
    end
    return count
end

local file, err = io.open('input.txt', 'r')
if not file then
    print('Could not open file: ' .. err)
    os.exit(1)
end

local strings = {}
for line in file:lines() do
    table.insert(strings, line)
end
file:close()

print('Part 1:', count_nice_strings(strings, is_nice_string))
print('Part 2:', count_nice_strings(strings, is_nice_string2))
