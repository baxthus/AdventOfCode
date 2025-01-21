local divider = 33554393
local initial_code = 20151125
local multiplier = 252533

local file = io.open('input.txt', 'r')
if not file then return nil end
local row, col = file:read('*all'):match('Enter the code at row (%d+), column (%d+).')
file:close()

row, col = tonumber(row), tonumber(col)

local diagonal = row + col - 1
local sequence_number = (diagonal * (diagonal - 1)) // 2 + col

local code = initial_code
for i = 2, sequence_number do
    code = (code * multiplier) % divider
end

print('Result: ' .. code)
