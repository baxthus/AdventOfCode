--- @param initial_data string
--- @param target_length number
--- @return string
local function generate_dragon_curve_data(initial_data, target_length)
  local current_data = initial_data
  while #current_data < target_length do
    local a = current_data
    local b_chars = {} --- @type string[]

    for i = #a, 1, -1 do
      local char = string.sub(a, i, i)
      if char == '0' then
        table.insert(b_chars, '1')
      else
        table.insert(b_chars, '0')
      end
    end
    local b = table.concat(b_chars)

    current_data = a .. '0' .. b
  end
  return string.sub(current_data, 1, target_length)
end

--- @param data_str string
--- @return string
local function compute_checksum(data_str)
  local checksum = data_str
  while #checksum % 2 == 0 do
    local new_checksum_parts = {} --- @type string[]
    for i = 1, #checksum, 2 do
      local char1 = string.sub(checksum, i, i)
      local char2 = string.sub(checksum, i + 1, i + 1)
      if char1 == char2 then
        table.insert(new_checksum_parts, '1')
      else
        table.insert(new_checksum_parts, '0')
      end
    end
    checksum = table.concat(new_checksum_parts)
    if #checksum == 0 then
      break
    end
  end
  return checksum
end

local initial_input = '11011110011011101'

local data = generate_dragon_curve_data(initial_input, 272)
print('Part 1: ' .. compute_checksum(data))

data = generate_dragon_curve_data(initial_input, 35651584)
print('Part 2: ' .. compute_checksum(data))
