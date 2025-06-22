---@param num_elves integer
---@return integer
local function part1(num_elves)
  local highest_power_of_2 = 1
  while highest_power_of_2 * 2 <= num_elves do
    highest_power_of_2 = highest_power_of_2 * 2
  end
  local l = num_elves - highest_power_of_2
  return 2 * l + 1
end

local function part2(num_elves)
  local p3 = 1
  while p3 * 3 <= num_elves do
    p3 = p3 * 3
  end

  if num_elves == p3 then
    return num_elves
  elseif num_elves <= 2 * p3 then
    return num_elves - p3
  else
    return 2 * num_elves - 3 * p3
  end
end

local num_elves = 3017957

print('Part 1: ' .. part1(num_elves))
print('Part 2: ' .. part2(num_elves))
