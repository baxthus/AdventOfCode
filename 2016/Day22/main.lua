---@class Node
---@field x integer
---@field y integer
---@field size integer
---@field used integer
---@field avail integer

---@class State
---@field empty_x integer
---@field empty_y integer
---@field goal_x integer
---@field goal_y integer
---@field steps integer

---@param state State
---@return string
local function state_to_key(state)
  return string.format("%d,%d,%d,%d", state.empty_x, state.empty_y, state.goal_x, state.goal_y)
end

---@param nodes Node[]
---@param max_x integer
---@param max_y integer
---@param empty_x integer
---@param empty_y integer
---@param goal_x integer
local function print_grid(nodes, max_x, max_y, empty_x, empty_y, goal_x)
  local grid = {}

  for y = 0, max_y do
    grid[y] = {}
    for x = 0, max_x do
      grid[y][x] = '.'
    end
  end

  for _, node in ipairs(nodes) do
    if node.used > 100 then
      grid[node.y][node.x] = '#'
    end
  end

  grid[empty_y][empty_x] = '_'
  grid[0][0] = 'O'
  grid[0][goal_x] = 'G'

  print('Grid visualization:')
  for y = 0, max_y do
    local row = {}
    for x = 0, max_x do
      table.insert(row, grid[y][x] .. ' ')
    end
    print(table.concat(row))
  end
end

---@param nodes Node[]
---@return integer
local function solve_part2(nodes)
  local max_x, max_y = 0, 0

  for _, node in ipairs(nodes) do
    max_x = math.max(max_x, node.x)
    max_y = math.max(max_y, node.y)
  end

  local empty_x, empty_y = -1, -1
  for _, node in ipairs(nodes) do
    if node.used == 0 then
      empty_x, empty_y = node.x, node.y
      break
    end
  end

  local goal_x, goal_y = max_x, 0

  local viable_nodes = {}
  for y = 0, max_y do
    viable_nodes[y] = {}
    for x = 0, max_x do
      viable_nodes[y][x] = true
    end
  end

  for _, node in ipairs(nodes) do
    if node.used > 100 then
      viable_nodes[node.y][node.x] = false
    end
  end

  print_grid(nodes, max_x, max_y, empty_x, empty_y, goal_x)

  local queue = {}
  local visited = {}

  ---@type State
  local start = {
    empty_x = empty_x,
    empty_y = empty_y,
    goal_x = goal_x,
    goal_y = goal_y,
    steps = 0
  }
  table.insert(queue, start)
  visited[state_to_key(start)] = true

  local dx = { 0, 1, 0, -1 }
  local dy = { -1, 0, 1, 0 }

  local index = 1
  while index <= #queue do
    local current = queue[index]
    index = index + 1

    if current.goal_x == 0 and current.goal_y == 0 then
      return current.steps
    end

    for dir = 1, 4 do
      local new_empty_x = current.empty_x + dx[dir]
      local new_empty_y = current.empty_y + dy[dir]

      if new_empty_x >= 0 and new_empty_x <= max_x and
          new_empty_y >= 0 and new_empty_y <= max_y and
          viable_nodes[new_empty_y][new_empty_x] then
        local new_goal_x = current.goal_x
        local new_goal_y = current.goal_y

        if new_empty_x == current.goal_x and new_empty_y == current.goal_y then
          new_goal_x = current.empty_x
          new_goal_y = current.empty_y
        end

        ---@type State
        local next_state = {
          empty_x = new_empty_x,
          empty_y = new_empty_y,
          goal_x = new_goal_x,
          goal_y = new_goal_y,
          steps = current.steps + 1
        }

        local key = state_to_key(next_state)
        if not visited[key] then
          visited[key] = true
          table.insert(queue, next_state)
        end
      end
    end
  end

  return -1
end

local nodes = {} ---@type Node[]

-- Skip first two lines

_ = io.read('*line')
_ = io.read('*line')

for line in io.lines() do
  local x, y, size, used, avail = line:match('node%-x(%d+)%-y(%d+)%s+(%d+)T%s+(%d+)T%s+(%d+)T')
  if x then
    table.insert(nodes, {
      x = tonumber(x),
      y = tonumber(y),
      size = tonumber(size),
      used = tonumber(used),
      avail = tonumber(avail)
    })
  end
end

local viable_pairs = 0
for i = 1, #nodes do
  for j = 1, #nodes do
    if i ~= j and nodes[i].used > 0 and nodes[i].used <= nodes[j].avail then
      viable_pairs = viable_pairs + 1
    end
  end
end

print('Number of viable pairs: ' .. viable_pairs)

local minSteps = solve_part2(nodes)
print('Minimum steps required: ' .. minSteps)
