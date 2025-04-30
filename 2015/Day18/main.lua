---@param filepath string
---@return table
local function read_input(filepath)
  local grid = {}
  for line in io.lines(filepath) do
    local row = {}
    for i = 1, #line do
      table.insert(row, line:sub(i, i))
    end
    table.insert(grid, row)
  end
  return grid
end

---@param grid table
---@param x number
---@param y number
---@return number
local function count_on_neighbors(grid, x, y)
  local count = 0
  for dx = -1, 1 do
    for dy = -1, 1 do
      if not (dx == 0 and dy == 0) then
        local nx, ny = x + dx, y + dy
        if nx >= 1 and nx <= #grid and ny >= 1 and ny <= #grid[1] then
          if grid[nx][ny] == '#' then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

---@param grid table
---@param corners boolean|nil
---@return table
local function step(grid, corners)
  local new_grid = {}
  for x = 1, #grid do
    new_grid[x] = {}
    for y = 1, #grid[1] do
      local count = count_on_neighbors(grid, x, y)
      if grid[x][y] == '#' then
        new_grid[x][y] = (count == 2 or count == 3) and '#' or '.'
      else
        new_grid[x][y] = (count == 3) and '#' or '.'
      end
    end
  end

  if corners then
    new_grid[1][1] = '#'
    new_grid[1][#grid[1]] = '#'
    new_grid[#grid][1] = '#'
    new_grid[#grid][#grid[1]] = '#'
  end

  return new_grid
end

---@param grid table
---@return number
local function count_on_lights(grid)
  local count = 0
  for x = 1, #grid do
    for y = 1, #grid[1] do
      if grid[x][y] == '#' then
        count = count + 1
      end
    end
  end
  return count
end

local grid = read_input('input.txt')
for i = 1, 100 do
  grid = step(grid)
end
print('Part 1: ' .. count_on_lights(grid))

grid = read_input('input.txt')
grid[1][1] = '#'
grid[1][#grid[1]] = '#'
grid[#grid][1] = '#'
grid[#grid][#grid[1]] = '#'

for i = 1, 100 do
  grid = step(grid, true)
end
print('Part 2: ' .. count_on_lights(grid))
