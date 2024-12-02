from itertools import combinations

def count_eggnog_combinations(containers, target):
    count = 0
    for r in range(1, len(containers) + 1):
        for combo in combinations(containers, r):
            if sum(combo) == target:
                count += 1
    return count

def find_min_containers_and_combinations(containers, target):
    for r in range(1, len(containers) + 1):
        count = 0
        for combo in combinations(containers, r):
            if sum(combo) == target:
                count += 1
        if count > 0:
            return r, count
    return None, 0

with open("input.txt") as f:
    containers = [int(line.strip()) for line in f]

target_volume = 150

print(f"Part 1: {count_eggnog_combinations(containers, target_volume)}")
print(f"Part 2: {find_min_containers_and_combinations(containers, target_volume)[1]}")