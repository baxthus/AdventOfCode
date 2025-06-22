import sys


RangeList = list[tuple[int, int]]

def part1(ranges: RangeList) -> int:
    lowest_allowed_ip = 0
    for start, end in ranges:
        if lowest_allowed_ip < start:
            break
        if lowest_allowed_ip <= end:
            lowest_allowed_ip = end + 1
    return lowest_allowed_ip

def part2(ranges: RangeList) -> int:
    total_ips = 2**32
    if not ranges:
        return total_ips
    
    merged_ranges: RangeList = []
    if ranges:
        current_start, current_end = ranges[0]
        for next_start, next_end in ranges[1:]:
            if next_start <= current_end + 1:
                current_end = max(current_end, next_end)
            else:
                merged_ranges.append((current_start, current_end))
                current_start, current_end = next_start, next_end
        merged_ranges.append((current_start, current_end))

    total_blocked_count = sum(end - start + 1 for start, end in merged_ranges)

    return total_ips - total_blocked_count

if __name__ == '__main__':
    ranges: RangeList = []
    for line in sys.stdin:
        start, end = map(int, line.strip().split('-'))
        ranges.append((start, end))
    
    ranges.sort()

    print(f'Part 1: {part1(ranges)}')
    print(f'Part 2: {part2(ranges)}')