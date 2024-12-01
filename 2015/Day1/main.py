def calculate_final_floor(instructions):
    floor = 0
    for char in instructions:
        if char == '(':
            floor += 1
        elif char == ')':
            floor -= 1
    return floor

def find_basement_entry(instructions):
    floor = 0
    for position, char in enumerate(instructions, start=1):
        if char == '(':
            floor += 1
        elif char == ')':
            floor -= 1

        if floor == -1:
            return position
    
    return None

with open('input.txt', 'r') as file:
    instructions = file.read().strip()

print(f"Santa ends up on floor: {calculate_final_floor(instructions)}")
print(f"Santa enters the basement at position: {find_basement_entry(instructions)}")