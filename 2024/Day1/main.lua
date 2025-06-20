local left = {}  --- @type number[]
local right = {} --- @type number[]

for line in io.lines() do
  local a_str, b_str = line:match('^(%-?%d+)%s+(%-?%d+)$')
  if a_str and b_str then
    local a = tonumber(a_str)
    local b = tonumber(b_str)
    table.insert(left, a)
    table.insert(right, b)
  end
end

table.sort(left)
table.sort(right)

local total_distance = 0
for i = 1, #left do
  if left[i] ~= nil and right[i] ~= nil then
    total_distance = total_distance + math.abs(left[i] - right[i])
  end
end

print('Part 1: ' .. total_distance)

local right_counts = {} --- @type table<number, number>
for _, num in ipairs(right) do
  right_counts[num] = (right_counts[num] or 0) + 1
end

local similarity_score = 0
for _, num_left in ipairs(left) do
  local count_in_right = right_counts[num_left] or 0
  similarity_score = similarity_score + (num_left * count_in_right)
end

print('Part 2: ' .. similarity_score)
