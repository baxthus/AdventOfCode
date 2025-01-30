local function is_valid_triangle(a, b, c)
    return (a + b > c) and (a + c > b) and (b + c > a)
end

local function count_valid_triangles_row(triangles)
    local valid_triangles = 0
    for _, triangle in ipairs(triangles) do
        if is_valid_triangle(triangle[1], triangle[2], triangle[3]) then
            valid_triangles = valid_triangles + 1
        end
    end
    return valid_triangles
end

local function count_valid_triangles_column(triangles)
    local valid_triangles = 0
    for i = 1, #triangles, 3 do
        if i + 2 <= #triangles then
            for j = 1, 3 do
                local a = triangles[i][j]
                local b = triangles[i + 1][j]
                local c = triangles[i + 2][j]
                if is_valid_triangle(a, b, c) then
                    valid_triangles = valid_triangles + 1
                end
            end
        end
    end
    return valid_triangles
end

local triangles = {}
for line in io.lines("input.txt") do
    local sides = {}
    for s in line:gmatch("%S+") do
        table.insert(sides, tonumber(s))
    end
    table.insert(triangles, sides)
end

print('Part 1: ' .. count_valid_triangles_row(triangles))
print('Part 2: ' .. count_valid_triangles_column(triangles))
