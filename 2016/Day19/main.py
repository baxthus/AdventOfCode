def part1(num_elves: int) -> int:
    highest_power_of_2 = 1 << (num_elves.bit_length() - 1)
    l = num_elves - highest_power_of_2
    return 2 * l + 1

def part2(num_elves: int) -> int:
    p3 = 1
    while p3 * 3 <= num_elves:
        p3 *= 3
    
    if num_elves == p3:
        return num_elves
    elif num_elves <= 2 * p3:
        return num_elves - p3
    else:
        return 2 * num_elves - 3 * p3

if __name__ == '__main__':
    num_elves = 3017957

    print(f'Part 1: {part1(num_elves)}')
    print(f'Part 2: {part2(num_elves)}')