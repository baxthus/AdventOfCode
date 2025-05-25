from collections import Counter
from dataclasses import dataclass
import sys

@dataclass
class Room:
    name: str
    sector_id: int
    checksum: str

def parse_input() -> list[Room]:
    rooms: list[Room] = []
    for line in sys.stdin:
        line = line.strip()
        if not line: continue

        last_dash = line.rfind('-')
        bracket_start = line.find('[')

        name_part = line[:last_dash]
        sector_id_str = int(line[last_dash + 1:bracket_start])
        checksum_part = line[bracket_start + 1:-1]

        rooms.append(Room(name_part, sector_id_str, checksum_part))

    return rooms

def calculate_checksum(name: str) -> str:
    frequency: Counter[str] = Counter()
    for char_code in name:
        if char_code != '-':
            frequency[char_code] += 1

    sorted_freq = sorted(frequency.items(), key=lambda item: (-item[1], item[0]))

    checksum = ''
    for i in range(min(5, len(sorted_freq))):
        checksum += sorted_freq[i][0]

    return checksum

def decrypt_name(name: str, sector_id: int) -> str:
    decrypted_name_chars: list[str] = []
    for char_code in name:
        if char_code == '-':
            decrypted_name_chars.append(' ')
        else:
            shifted_char_val = (ord(char_code) - ord('a') + sector_id) % 26
            decrypted_name_chars.append(chr(ord('a') + shifted_char_val))

    return ''.join(decrypted_name_chars)

if __name__ == '__main__':
    rooms = parse_input()
    sum_of_sector_ids = 0
    north_pole_sector_id = -1

    for room in rooms:
        calculated_checksum = calculate_checksum(room.name)
        if calculated_checksum == room.checksum:
            sum_of_sector_ids += room.sector_id
            decrypted_name = decrypt_name(room.name, room.sector_id)
            if 'northpole' in decrypted_name:
                north_pole_sector_id = room.sector_id

    print(f'Part 1: {sum_of_sector_ids}')
    print(f'Part 2: {north_pole_sector_id}')
