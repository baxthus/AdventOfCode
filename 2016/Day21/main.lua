---@param s string
---@param delimiter string
---@return string[]
local function split(s, delimiter)
  local result = {}
  for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

---@param tbl any[]
---@param value any
---@return number | nil
local function table_find(tbl, value)
  for i, v in ipairs(tbl) do
    if v == value then
      return i
    end
  end
  return nil
end

---@param tbl any[]
---@param pos1 number
---@param pos2 number
local function reverse_slice(tbl, pos1, pos2)
  while pos1 < pos2 do
    tbl[pos1], tbl[pos2] = tbl[pos2], tbl[pos1]
    pos1 = pos1 + 1
    pos2 = pos2 - 1
  end
end

---@param tbl any[]
---@param steps number
local function rotate(tbl, steps)
  local n = #tbl
  if n == 0 then return end
  steps = steps % n
  if steps == 0 then return end

  if steps < 0 then
    steps = -steps
    reverse_slice(tbl, 1, steps)
    reverse_slice(tbl, steps + 1, n)
    reverse_slice(tbl, 1, n)
  else
    reverse_slice(tbl, 1, n - steps)
    reverse_slice(tbl, n - steps + 1, n)
    reverse_slice(tbl, 1, n)
  end
end

---@param s string
---@return string[]
local function string_to_char_table(s)
  local t = {}
  for i = 1, #s do
    t[i] = s:sub(i, i)
  end
  return t
end

---@param password string[]
---@param instruction string
---@return string[]
local function scramble(password, instruction)
  local p = {}
  for _, v in ipairs(password) do
    table.insert(p, v)
  end

  local parts = split(instruction, ' ')

  if parts[1] == 'swap' then
    if parts[2] == 'position' then
      local pos1 = tonumber(parts[3]) + 1
      local pos2 = tonumber(parts[6]) + 1
      p[pos1], p[pos2] = p[pos2], p[pos1]
    elseif parts[2] == 'letter' then
      local let1, let2 = parts[3], parts[6]
      local pos1 = table_find(p, let1)
      local pos2 = table_find(p, let2)
      if pos1 and pos2 then
        p[pos1], p[pos2] = p[pos2], p[pos1]
      end
    end
  elseif parts[1] == 'rotate' then
    if parts[2] == 'left' then
      local steps = tonumber(parts[3])
      rotate(p, -steps)
    elseif parts[2] == 'right' then
      local steps = tonumber(parts[3])
      assert(steps)
      rotate(p, steps)
    elseif parts[2] == 'based' then
      local letter = parts[7]
      local idx = table_find(p, letter)
      if idx then
        local rotations = idx
        if idx >= 5 then
          rotations = rotations + 1
        end
        rotate(p, rotations)
      end
    end
  elseif parts[1] == 'reverse' then
    local pos1 = tonumber(parts[3]) + 1
    local pos2 = tonumber(parts[5]) + 1
    reverse_slice(p, pos1, pos2)
  elseif parts[1] == 'move' then
    local pos1 = tonumber(parts[3]) + 1
    local pos2 = tonumber(parts[6]) + 1
    local letter = table.remove(p, pos1)
    table.insert(p, pos2, letter)
  end

  return p
end

local unscramble_rotate_map = {
  [1] = 8,
  [2] = 1,
  [3] = 5,
  [4] = 2,
  [5] = 6,
  [6] = 3,
  [7] = 7,
  [8] = 4
}

---@param password string[]
---@param instruction string
---@return string[]
local function unscramble(password, instruction)
  local p = {}
  for _, v in ipairs(password) do
    table.insert(p, v)
  end

  local parts = split(instruction, ' ')

  if parts[1] == 'swap' then
    return scramble(p, instruction)
  elseif parts[1] == 'rotate' then
    if parts[2] == 'left' then
      local steps = tonumber(parts[3])
      assert(steps)
      rotate(p, steps)
    elseif parts[2] == 'right' then
      local steps = tonumber(parts[3])
      rotate(p, -steps)
    elseif parts[2] == 'based' then
      local letter = parts[7]
      local current_idx = table_find(p, letter)
      if current_idx then
        local original_idx = unscramble_rotate_map[current_idx]
        local rotations = original_idx
        if original_idx >= 5 then
          rotations = rotations + 1
        end
        rotate(p, -rotations)
      end
    end
  elseif parts[1] == 'reverse' then
    return scramble(p, instruction)
  elseif parts[1] == 'move' then
    local pos1 = tonumber(parts[3]) + 1
    local pos2 = tonumber(parts[6]) + 1
    local letter = table.remove(p, pos2)
    table.insert(p, pos1, letter)
  end

  return p
end

local instructions = {}
for line in io.lines() do
  if line ~= '' then
    table.insert(instructions, line)
  end
end

local password1 = string_to_char_table('abcdefgh')
for _, instruction in ipairs(instructions) do
  password1 = scramble(password1, instruction)
end
print('Part 1: ' .. table.concat(password1))

local password2 = string_to_char_table('fbgdceah')
for i = #instructions, 1, -1 do
  password2 = unscramble(password2, instructions[i])
end
print('Part 2: ' .. table.concat(password2))
