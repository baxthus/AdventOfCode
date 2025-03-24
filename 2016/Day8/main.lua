local Display = {}
Display.__index = Display

function Display:new()
    self = setmetatable({}, Display)
    self.WIDTH = 50
    self.HEIGHT = 6

    -- Initialize the screen with all pixels off
    self.screen = {}
    for y = 1, self.HEIGHT do
        self.screen[y] = {}
        for x = 1, self.WIDTH do
            self.screen[y][x] = false
        end
    end

    return self
end

---@param width number
---@param height number
function Display:rect(width, height)
    for y = 1, height do
        for x = 1, width do
            self.screen[y][x] = true
        end
    end
end

---@param row number
---@param amount number
function Display:rotate_row(row, amount)
    -- Save the original row
    local oldRow = {}
    for x = 1, self.WIDTH do
        oldRow[x] = self.screen[row][x]
    end

    -- Rotate the row
    for x = 1, self.WIDTH do
        self.screen[row][(x + amount - 1) % self.WIDTH + 1] = oldRow[x]
    end
end

---@param col number
---@param amount number
function Display:rotate_column(col, amount)
    -- Save the original column
    local oldCol = {}
    for y = 1, self.HEIGHT do
        oldCol[y] = self.screen[y][col]
    end

    -- Rotate the column
    for y = 1, self.HEIGHT do
        self.screen[(y + amount - 1) % self.HEIGHT + 1][col] = oldCol[y]
    end
end

---@return number
function Display:count_lit_pixels()
    local count = 0
    for y = 1, self.HEIGHT do
        for x = 1, self.WIDTH do
            if self.screen[y][x] then
                count = count + 1
            end
        end
    end
    return count
end

function Display:print_screen()
    for y = 1, self.HEIGHT do
        local row = ""
        for x = 1, self.WIDTH do
            row = row .. (self.screen[y][x] and "#" or ".")
        end
        print(row)
    end
end

local display = Display:new()

for line in io.lines('input.txt') do
    local parts = {}
    for part in line:gmatch('%S+') do
        table.insert(parts, part)
    end

    if parts[1] == 'rect' then
        local rawWidth, rawHeight = parts[2]:match('(%d+)x(%d+)')
        local width, height = tonumber(rawWidth), tonumber(rawHeight)
        assert(width and height, 'Invalid input')
        display:rect(width, height)
    elseif parts[1] == 'rotate' then
        if parts[2] == 'row' then
            local row = tonumber(parts[3]:match('y=(%d+)'))
            local amount = tonumber(parts[5])
            assert(row and amount, 'Invalid input')
            display:rotate_row(row + 1, amount) -- +1 because Lua arrays are 1-indexed
        elseif parts[2] == 'column' then
            local col = tonumber(parts[3]:match('x=(%d+)'))
            local amount = tonumber(parts[5])
            assert(col and amount, 'Invalid input')
            display:rotate_column(col + 1, amount) -- +1 because Lua arrays are 1-indexed
        end
    end
end

print('Number of lit pixels: ' .. display:count_lit_pixels())
print('Display:')
display:print_screen()
