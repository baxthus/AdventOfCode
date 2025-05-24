--- @alias Happiness table<string, number>
--- @alias People string[]

--- @param lines string[]
--- @return Happiness, People
local function parse_input(lines)
  --- @type Happiness
  local happiness = {}
  --- @type table<string, boolean>
  local peopleSet = {}
  --- @type People
  local peopleList = {}

  for _, line in ipairs(lines) do
    local parts = {}
    for part in string.gmatch(line, '%S+') do
      table.insert(parts, part)
    end
    local person1 = parts[1]
    local person2 = string.gsub(parts[#parts], '%.', '')
    local value = tonumber(parts[4])
    if parts[3] == 'lose' then
      value = -value
    end
    happiness[person1 .. ',' .. person2] = value
    if not peopleSet[person1] then
      peopleSet[person1] = true
      table.insert(peopleList, person1)
    end
  end

  return happiness, peopleList
end


--- @param lines string[]
--- @return Happiness, People
local function parse_input2(lines)
  --- @type Happiness
  local happiness = {}
  --- @type table<string, boolean>
  local peopleSet = {}
  --- @type People
  local peopleList = {}

  for _, line in ipairs(lines) do
    local parts = {}
    for part in string.gmatch(line, '%S+') do
      table.insert(parts, part)
    end
    local person1 = parts[1]
    local person2 = string.gsub(parts[#parts], '%.', '')
    local value = tonumber(parts[4])
    if parts[3] == 'lose' then
      value = -value
    end
    happiness[person1 .. ',' .. person2] = value
    if not peopleSet[person1] then
      peopleSet[person1] = true
      table.insert(peopleList, person1)
    end
  end

  local you = "You"
  for _, person in ipairs(peopleList) do
    happiness[you .. ',' .. person] = 0
    happiness[person .. ',' .. you] = 0
  end
  table.insert(peopleList, you)

  return happiness, peopleList
end

--- @param people People
--- @param happiness Happiness
--- @return number
local function calculate_happiness(people, happiness)
  local total = 0
  local n = #people
  for i = 1, n do
    local person = people[i]
    local left = people[((i - 2) % n) + 1]
    local right = people[(i % n) + 1]
    total = total + (happiness[person .. ',' .. left] or 0)
    total = total + (happiness[person .. ',' .. right] or 0)
  end
  return total
end

--- @param list People
--- @return People[]
local function permute(list)
  if #list == 0 then
    return { {} }
  end

  --- @type People[]
  local result = {}
  for i = 1, #list do
    local element = list[i]
    --- @type People
    local rest = {}
    for j = 1, #list do
      if i ~= j then
        table.insert(rest, list[j])
      end
    end
    for _, perm in ipairs(permute(rest)) do
      --- @type People
      local currentPerm = { element }
      for _, item in ipairs(perm) do
        table.insert(currentPerm, item)
      end
      table.insert(result, currentPerm)
    end
  end
  return result
end

--- @param happiness Happiness
--- @param people People
--- @return number
local function find_optimal_arrangement(happiness, people)
  local max_happiness = -math.huge
  --- @type People
  local sublist = {}
  for i = 2, #people do
    table.insert(sublist, people[i])
  end
  local permutations = permute(sublist)

  for _, arrangement in ipairs(permutations) do
    local currentArrangement = { people[1] }
    for _, person in ipairs(arrangement) do
      table.insert(currentArrangement, person)
    end
    local current_happiness = calculate_happiness(currentArrangement, happiness)
    max_happiness = math.max(max_happiness, current_happiness)
  end

  return max_happiness
end

local lines = {}
for line in io.lines() do
  table.insert(lines, line)
end

local happiness, people = parse_input(lines)
local happiness2, people2 = parse_input2(lines)

print('Part 1: ' .. find_optimal_arrangement(happiness, people))
print('Part 2: ' .. find_optimal_arrangement(happiness2, people2))
