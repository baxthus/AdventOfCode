def parse_instruction(instruction):
    parts = instruction.split(' -> ')
    output = parts[1].strip()
    input_parts = parts[0].split()

    if len(input_parts) == 1:
        return output, ('ASSIGN', input_parts[0])
    elif len(input_parts) == 2:
        return output, ('NOT', input_parts[1])
    else:
        return output, (input_parts[1], input_parts[0], input_parts[2])

def evaluate(wire, circuit, memo):
    if (wire.isdigit()):
        return int(wire)
    if wire in memo:
        return memo[wire]
    
    operation = circuit[wire]

    if operation[0] == 'ASSIGN':
        result = evaluate(operation[1], circuit, memo)
    elif operation[0] == 'NOT':
        result = ~evaluate(operation[1], circuit, memo) & 0xffff
    elif operation[0] == 'AND':
        result = evaluate(operation[1], circuit, memo) & evaluate(operation[2], circuit, memo)
    elif operation[0] == 'OR':
        result = evaluate(operation[1], circuit, memo) | evaluate(operation[2], circuit, memo)
    elif operation[0] == 'LSHIFT':
        result = evaluate(operation[1], circuit, memo) << evaluate(operation[2], circuit, memo) & 0xffff
    elif operation[0] == 'RSHIFT':
        result = evaluate(operation[1], circuit, memo) >> int(operation[2])
    
    memo[wire] = result
    return result

def solve_circuit(instructions, override_b=None):
    circuit = {}
    for instruction in instructions:
        output, operation = parse_instruction(instruction)
        circuit[output] = operation

    if override_b is not None:
        circuit['b'] = ('ASSIGN', str(override_b))

    memo = {}
    return evaluate('a', circuit, memo)

with open('input.txt', 'r') as file:
    instructions = file.read().splitlines()

part1 = solve_circuit(instructions)
print(f"Part 1: {part1}")
print(f"Part 2: {solve_circuit(instructions, override_b=part1)}")