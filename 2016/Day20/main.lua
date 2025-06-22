---@class Range
---@field first number
---@field second number

---@param ranges Range[]
---@return number
local function part1(ranges)
  local lowest_allowed_ip = 0

  for _, range in ipairs(ranges) do
    if lowest_allowed_ip < range.first then break end

    if lowest_allowed_ip <= range.second then
      lowest_allowed_ip = range.second + 1
    end
  end

  return lowest_allowed_ip
end

---@param ranges Range[]
---@return number
local function part2(ranges)
  if #ranges == 0 then return 0 end

  local total_blocked_count = 0
  local merged_start = ranges[1].first
  local merged_end = ranges[1].second

  for i = 2, #ranges do
    if ranges[i].first <= merged_end + 1 then
      if ranges[i].second > merged_end then
        merged_end = ranges[i].second
      end
    else
      total_blocked_count = total_blocked_count + (merged_end - merged_start + 1)
      merged_start = ranges[i].first
      merged_end = ranges[i].second
    end
  end
  total_blocked_count = total_blocked_count + (merged_end - merged_start + 1)

  local total_ips = 4294967296 -- 2^32
  return total_ips - total_blocked_count
end

local ranges = {} ---@type Range[]

for line in io.lines() do
  local start_str, end_str = line:match('^(%d+)-(%d+)$')
  if start_str and end_str then
    table.insert(ranges, { first = tonumber(start_str), second = tonumber(end_str) })
  end
end

table.sort(ranges, function(a, b)
  return a.first < b.first
end)

print('Part 1: ' .. part1(ranges))
print('Part 2: ' .. part2(ranges))
