--- @class Disc
--- @field id integer -- Disc number (k)
--- @field num_pos integer -- Number of positions (N_k)
--- @field start_pos integer -- Starting position at time=0 (P_k)

--- @param T integer
--- @param discs Disc[]
--- @return boolean
local function check_time(T, discs)
  for _, disc in ipairs(discs) do
    local time_at_disc = T + disc.id
    local position_at_time = (disc.start_pos + time_at_disc) % disc.num_pos
    if position_at_time ~= 0 then
      return false
    end
  end
  return true
end

--- @param discs Disc[]
--- @return integer
local function find_first_valid_time(discs)
  local T = 0
  while true do
    if check_time(T, discs) then
      return T
    end
    T = T + 1
  end
  return -1 -- Just in case
end

--- @type Disc[]
local discs = {}
local max_id = 0

local pattern = "Disc #(%d+) has (%d+) positions; at time=0, it is at position (%d+)."

for line in io.lines() do
  if line ~= "" then
    local id_str, num_pos_str, start_pos_str = string.match(line, pattern)

    if id_str then
      local id = tonumber(id_str)
      local num_pos = tonumber(num_pos_str)
      local start_pos = tonumber(start_pos_str)

      if id and num_pos and start_pos then
        --- @type Disc
        local new_disc = { id = id, num_pos = num_pos, start_pos = start_pos }
        table.insert(discs, new_disc)
        if id > max_id then
          max_id = id
        end
      end
    end
  end
end

if #discs == 0 then
  print("No discs found.")
  return
end

local T1 = find_first_valid_time(discs)
print("First time the capsule passes through all discs: " .. T1)

local new_disc_id = max_id + 1
local new_disc_num_pos = 11
local new_disc_start_pos = 0
--- @type Disc
local new_disc = { id = new_disc_id, num_pos = new_disc_num_pos, start_pos = new_disc_start_pos }
table.insert(discs, new_disc)

local T2 = find_first_valid_time(discs)
print("First time the capsule passes through all discs (with new disc): " .. T2)
