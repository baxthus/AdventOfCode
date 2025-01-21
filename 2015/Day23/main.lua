local function read_instructions(filename)
    local instructions = {}
    for line in io.lines(filename) do
        local parts = {}
        for part in string.gmatch(line, "%S+") do
            table.insert(parts, part)
        end

        local op = parts[1]
        local reg = ''
        local offset = 0

        if op == 'hlf' or op == 'tpl' or op == 'inc' then
            reg = parts[2]
        elseif op == 'jmp' then
            offset = tonumber(parts[2]) or 0
        elseif op == 'jie' or op == 'jio' then
            reg = string.sub(parts[2], 1, -2)
            offset = tonumber(parts[3]) or 0
        end

        table.insert(instructions, { op = op, reg = reg, offset = offset })
    end
    return instructions
end

local function execute_program(instructions, part2)
    part2 = part2 or false
    local registers = { a = part2 and 1 or 0, b = 0 }
    local pc = 0

    while pc >= 0 and pc < #instructions do
        local instr = instructions[pc + 1]

        if instr.op == 'hlf' then
            registers[instr.reg] = math.floor(registers[instr.reg] / 2)
            pc = pc + 1
        elseif instr.op == 'tpl' then
            registers[instr.reg] = registers[instr.reg] * 3
            pc = pc + 1
        elseif instr.op == 'inc' then
            registers[instr.reg] = registers[instr.reg] + 1
            pc = pc + 1
        elseif instr.op == 'jmp' then
            pc = pc + instr.offset
        elseif instr.op == 'jie' then
            if registers[instr.reg] % 2 == 0 then
                pc = pc + instr.offset
            else
                pc = pc + 1
            end
        elseif instr.op == 'jio' then
            if registers[instr.reg] == 1 then
                pc = pc + instr.offset
            else
                pc = pc + 1
            end
        end
    end

    return registers.b
end

local instructions = read_instructions('input.txt')
print('Part 1:', execute_program(instructions))
print('Part 2:', execute_program(instructions, true))
