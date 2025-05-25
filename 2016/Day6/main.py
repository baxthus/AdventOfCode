from collections import Counter
import sys


def decode_message(messages: list[str], find_least_frequent: bool = False) -> str:
    if not messages: return ''

    num_columns = len(messages[0])
    frequency_maps: list[Counter[str]] = [Counter() for _ in range(num_columns)]

    for message in messages:
        for i in range(num_columns):
            frequency_maps[i][message[i]] += 1

    decoded_message = []
    for frequency_map in frequency_maps:
        if not frequency_map:
            decoded_message.append('')
            continue

        if find_least_frequent:
            selected_char = min(frequency_map.items(), key=lambda item: item[1])[0]
        else:
            selected_char = max(frequency_map.items(), key=lambda item: item[1])[0]

        decoded_message.append(selected_char)

    return ''.join(decoded_message)

if __name__ == '__main__':
    messages = [line.strip() for line in sys.stdin if line.strip()]

    print(f'Part 1: {decode_message(messages)}')
    print(f'Part 2: {decode_message(messages, True)}')
