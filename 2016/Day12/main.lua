local function read_instructions(filename)
	local instructions = {}
	for line in io.lines(filename) do
		local parts = {}
		for part in line:gmatch("%S+") do
			table.insert(parts, part)
		end
		table.insert(instructions, {
			op = parts[1],
			x = parts[2],
			y = parts[3],
		})
	end
	return instructions
end

local function get_value(operand, registers)
	if operand:match("^%a") then
		return registers[operand]
	else
		return tonumber(operand)
	end
end

local function execute_program(instructions, registers)
	local pc = 1 -- Lua uses 1-based indexing
	while pc >= 1 and pc <= #instructions do
		local instr = instructions[pc]

		if instr.op == "cpy" then
			local value = get_value(instr.x, registers)
			registers[instr.y] = value
			pc = pc + 1
		elseif instr.op == "inc" then
			registers[instr.x] = (registers[instr.x] or 0) + 1
			pc = pc + 1
		elseif instr.op == "dec" then
			registers[instr.x] = (registers[instr.x] or 0) - 1
			pc = pc + 1
		elseif instr.op == "jnz" then
			local value = get_value(instr.x, registers)
			if value ~= 0 then
				pc = pc + tonumber(instr.y)
			else
				pc = pc + 1
			end
		else
			error("Unknown instructions: " .. instr.op)
		end
	end
end

local instructions = read_instructions("input.txt")

local registers = { a = 0, b = 0, c = 0, d = 0 }
execute_program(instructions, registers)
print("Value in register a: " .. registers.a)

registers = { a = 0, b = 0, c = 1, d = 0 }
execute_program(instructions, registers)
print("Value in register a: " .. registers.a)
