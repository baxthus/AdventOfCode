import sys


def decompossed_length(input: str) -> int:
    length = 0
    i = 0
    n = len(input)

    while i < n:
        if input[i] == '(':
            marker_end_idx = input.index(')', i)
            marker_content = input[i + 1:marker_end_idx]

            x_pos = marker_content.index('x')

            chars_to_repeat = int(marker_content[:x_pos])
            repeat_count = int(marker_content[x_pos + 1:])

            i = marker_end_idx + 1
            length += chars_to_repeat * repeat_count
            i += chars_to_repeat
        elif not input[i].isspace():
            length += 1
            i += 1
        else:
            i += 1

    return length

memo = {}

def decompossed_length_memo(input: str, start_index: int = 0, end_index: int = -1) -> int:
    global memo

    actual_end_index = len(input) if end_index == -1 else end_index
    if start_index >= actual_end_index:
        return 0

    memo_key = (start_index, actual_end_index)
    if memo_key in memo:
        return memo[memo_key]

    current_length = 0
    i = start_index

    while i < actual_end_index:
        if input[i] == '(':
            marker_end_idx = input.find(')', i)
            if marker_end_idx == -1:
                return -1

            marker_content = input[i + 1:marker_end_idx]
            x_pos = marker_content.index('x')

            chars_to_repeat = int(marker_content[:x_pos])
            repeat_count = int(marker_content[x_pos + 1:])

            data_segment_start_abs = marker_end_idx + 1
            data_segment_end_abs = data_segment_start_abs + chars_to_repeat

            repeated_segment_len = decompossed_length_memo(input, data_segment_start_abs, data_segment_end_abs)
            if repeated_segment_len == -1:
                return -1

            current_length += repeated_segment_len * repeat_count
            i = data_segment_end_abs
        elif not input[i].isspace():
            current_length += 1
            i += 1
        else:
            i += 1

    memo[memo_key] = current_length
    return current_length

if __name__ == '__main__':
    input = sys.stdin.read()

    print(f'Part 1: {decompossed_length(input)}')
    memo.clear() # Just to be sure
    print(f'Part 2: {decompossed_length_memo(input)}')
