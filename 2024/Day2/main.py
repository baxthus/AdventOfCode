def is_safe(levels):
    if len(levels) < 2:
        return False
    
    diff = levels[1] - levels[0]
    if abs(diff) < 1 or abs(diff) > 3:
        return False
    
    for i in range(2, len(levels)):
        new_diff = levels[i] - levels[i-1]
        if new_diff * diff <= 0 or abs(new_diff) < 1 or abs(new_diff) > 3:
            return False
        diff = new_diff

    return True

def is_safe_with_dampener(levels):
    if len(levels) < 2:
        return False
    
    if is_safe(levels):
        return True
    
    for i in range(len(levels)):
        dampened_levels = levels[:i] + levels[i+1:]
        if is_safe(dampened_levels):
            return True
    
    return False

safe_count = 0
safe_count_with_dampener = 0

with open('input.txt', 'r') as file:
    for line in file:
        levels = list(map(int, line.strip().split()))
        if is_safe(levels):
            safe_count += 1
        if is_safe_with_dampener(levels):
            safe_count_with_dampener += 1

print(f'Part 1: {safe_count}')
print(f'Part 2: {safe_count_with_dampener}')