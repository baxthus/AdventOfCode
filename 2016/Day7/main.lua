local function contains_abba(s)
    for i = 1, #s - 3 do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) and
           s:sub(i, i) == s:sub(i + 3, i + 3) and
           s:sub(i + 1, i + 1) == s:sub(i + 2, i + 2) then
            return true
        end
    end
    return false
end

local function collect_aba(s)
    local aba = {}
    for i = 1, #s - 2 do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) and
           s:sub(i, i) == s:sub(i + 2, i + 2) then
            table.insert(aba, s:sub(i, i + 2))
        end
    end
    return aba
end

local function contains_bab(s, abas)
    for i = 1, #s - 2 do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) and
           s:sub(i, i) == s:sub(i + 2, i + 2) then
           local bab = s:sub(i + 1, i + 1) .. s:sub(i, i) .. s:sub(i + 1, i + 1)
           for _, aba in ipairs(abas) do
               if aba == bab then
                   return true
               end
           end
        end
    end
    return false
end

local function split_segments(ip, supernet, hypernet)
    local inside_brackets = false
    local last_index = 1

    for i = 1, #ip do
        local char = ip:sub(i, i)
        if char == '[' then
            if i > last_index then
                table.insert(supernet, ip:sub(last_index, i - 1))
            end
            inside_brackets = true
            last_index = i + 1
        elseif char == ']' then
            if i > last_index then
                table.insert(hypernet, ip:sub(last_index, i - 1))
            end
            inside_brackets = false
            last_index = i + 1
        end
    end

    if last_index <= #ip then
        local segment = ip:sub(last_index)
        if inside_brackets then
            table.insert(hypernet, segment)
        else
            table.insert(supernet, segment)
        end
    end
end

local ips = {}
for line in io.lines('input.txt') do
    table.insert(ips, line)
end

local tls_count = 0
local ssl_count = 0

for _, ip in ipairs(ips) do
    local supernet = {}
    local hypernet = {}
    split_segments(ip, supernet, hypernet)

    local has_abba_outside = false
    local has_abba_inside = false

    for _, segment in ipairs(supernet) do
        if contains_abba(segment) then
            has_abba_outside = true
            break
        end
    end

    for _, segment in ipairs(hypernet) do
        if contains_abba(segment) then
            has_abba_inside = true
            break
        end
    end

    if has_abba_outside and not has_abba_inside then
        tls_count = tls_count + 1
    end

    local abas = {}
    for _, segment in ipairs(supernet) do
        for _, aba in ipairs(collect_aba(segment)) do
            table.insert(abas, aba)
        end
    end

    local supports_ssl = false
    for _, segment in ipairs(hypernet) do
        if contains_bab(segment, abas) then
            supports_ssl = true
            break
        end
    end

    if supports_ssl then
        ssl_count = ssl_count + 1
    end
end

print('Part 1: ' .. tls_count)
print('Part 2: ' .. ssl_count)
