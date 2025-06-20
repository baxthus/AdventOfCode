--- @param levels number[]
--- @return boolean
local function is_safe(levels)
  if #levels < 2 then
    return true
  end

  local increasing = levels[2] > levels[1]

  for i = 2, #levels do
    local diff = levels[i] - levels[i - 1]

    if increasing then
      if diff <= 0 then
        return false
      end
    else
      if diff >= 0 then
        return false
      end
    end

    local abs_diff = math.abs(diff)
    if abs_diff < 1 or abs_diff > 3 then
      return false
    end
  end

  return true
end

--- @param levels table<number>
--- @return boolean
local function is_safe_with_dampener(levels)
  if is_safe(levels) then
    return true
  end

  for i = 1, #levels do
    local temp_levels = {} --- @type number[]
    for k = 1, #levels do
      if k ~= i then
        table.insert(temp_levels, levels[k])
      end
    end

    if is_safe(temp_levels) then
      return true
    end
  end

  return false
end

local safe_count = 0
local safe_count_with_dampener = 0

for line in io.stdin:lines() do
  local levels = {} --- @type number[]
  for num_str in string.gmatch(line, '%-?%d+') do
    table.insert(levels, tonumber(num_str))
  end

  if is_safe(levels) then
    safe_count = safe_count + 1
  end
  if is_safe_with_dampener(levels) then
    safe_count_with_dampener = safe_count_with_dampener + 1
  end
end

print('Part 1: ' .. safe_count)
print('Part 2: ' .. safe_count_with_dampener)
