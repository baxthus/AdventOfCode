--- @class Point An object representing a coordinate
--- @field x integer The x-coordinate
--- @field y integer The y-coordinate

--- @class QueueItem An item stored in the BFS queue
--- @field x integer The x-coordinate
--- @field y integer The y-coordinate
--- @field steps integer The number of steps taken to reach this coordinate

local FAVORITE_NUMBER = 1364

--- Memoization table for is_wall results to avoid redundant calculations
--- @type table<string, boolean>
local wall_cache = {}

--- Counts the number of set bits (1s) in the binary representation of an integer
--- Uses Brian Kernighan's algorithm
--- Assumes Lua version with bitwise operations support
--- @param n integer The number to count bits for
--- @return integer The count of set bits
local function count_set_bits(n)
  local count = 0
  local num = n
  -- Lua's bitwise operations work on numbers by first converting them to integers
  -- The algorithm handles positive integers correctly. The formula result is expected to be positive
  while num ~= 0 do
    num = num & (num - 1) -- Clears the least significant set bit
    count = count + 1
  end
  return count
end

--- Checks if a given coordinate (x, y) is a wall based on the problem's formula
--- Uses memoization to cache results for efficiency
--- @param x integer The x-coordinate
--- @param y integer The y-coordinate
--- @return boolean true if the coordinate is a wall, false otherwise
local function is_wall(x, y)
  -- The BFS ensures x and y are non-negative before calling this function
  local key = x .. ',' .. y
  if wall_cache[key] ~= nil then
    return wall_cache[key]
  end

  local formula = x * x + 3 * x + 2 * x * y + y + y * y + FAVORITE_NUMBER
  local num_bits = count_set_bits(formula)
  local result = (num_bits % 2) ~= 0

  wall_cache[key] = result
  return result
end

--- @param start_x integer The starting x-coordinate
--- @param start_y integer The starting y-coordinate
--- @param target_x integer The target x-coordinate (relevant for Part 1-style calls)
--- @param target_y integer The target y-coordinate (relevant for Part 1-style calls)
--- @param max_steps_param integer? Optional: The maximum number of steps for Part 2-style calls
--- @return integer The number of steps (if `max_steps` is 0/nil and path found) or count of reachable locations (if `max_steps` > 0). Returns -1 if path not found for Part 1-style call
local function bfs(start_x, start_y, target_x, target_y, max_steps_param)
  local max_steps = max_steps_param or 0

  local q = {}            --- @type QueueItem[] Use a table as a queue with head/tail pointers for 0(1) enqueue/dequeue
  local q_head = 1        -- Index of the next item to dequeue
  local q_tail = 0        -- Index where the next item will be enqueued

  local visited = {}      --- @type table<string, boolean> Stores visited coordinates (e.g., 'x, y' -> true)
  local visited_count = 0 -- Tracks the number of items in the visited set for efficiency

  -- Helper to enqueue an item
  local function enqueue(item_x, item_y, item_steps)
    q_tail = q_tail + 1
    q[q_tail] = { x = item_x, y = item_y, steps = item_steps }
  end

  -- Helper to dequeue an item
  --- @return QueueItem?
  local function dequeue()
    if q_head > q_tail then return nil end -- Queue is empty
    local item = q[q_head]
    q[q_head] = nil                        -- Clear the reference to help with garbage collection
    q_head = q_head + 1
    return item
  end

  -- Initialize BFS with the starting positions
  enqueue(start_x, start_y, 0)
  local initial_key = start_x .. ',' .. start_y
  visited[initial_key] = true
  visited_count = 1

  while q_head <= q_tail do   -- While queue is not empty
    local current = dequeue() -- current will not be nil here due to the loop condition
    assert(current, "current should not be nil here")

    local x = current.x
    local y = current.y
    local steps = current.steps

    -- Part 1: Check if the target is reached
    if max_steps == 0 and x == target_x and y == target_y then
      return steps
    end

    -- Part 2: Check if current node's steps reach max_steps, it's counted (already in visited),
    -- but we don't explore its children further. This ensures we count locations reachable
    -- in *at most* max_steps
    if max_steps ~= 0 and steps >= max_steps then
      goto continue_bfs_loop -- Skip exploring children for this node
    end

    --- @type {dx: integer, dy: integer}[] Possible moves: right, left, down, up
    local directions = {
      { dx = 1, dy = 0 }, { dx = -1, dy = 0 },
      { dx = 0, dy = 1 }, { dx = 0, dy = -1 }
    }

    for _, dir in ipairs(directions) do
      local new_x = x + dir.dx
      local new_y = y + dir.dy

      -- Check if the new coordinate is valid (non-negative)
      if new_x >= 0 and new_y >= 0 then
        local key = new_x .. ',' .. new_y
        if not visited[key] then            -- If not already visited
          if not is_wall(new_x, new_y) then -- And if it's not a wall
            local new_steps = steps + 1
            enqueue(new_x, new_y, new_steps)
            visited[key] = true
            visited_count = visited_count + 1
          end
        end
      end
    end

    ::continue_bfs_loop::
  end

  -- If max_steps was specified (Part 2), return the total count of visited locations
  if max_steps ~= 0 then
    return visited_count
  end

  -- If loop finishes and target not found (Part 1 context)
  return -1
end

local start_x, start_y = 1, 1
local target_x, target_y = 31, 39

print('Part 1: ' .. bfs(start_x, start_y, target_x, target_y))
print('Part 2: ' .. bfs(start_x, start_y, target_x, target_y, 50))
