def generate_dragon_curve_data(initial_input: str, length: int) -> str:
    data = initial_input
    while len(data) < length:
        b = data[::-1] # Reverse the string
        b = ''.join(['1' if char == '0' else '0' for char in b]) # Flip bits
        data = f'{data}0{b}'
    return data[:length]

def compute_checksum(data: str) -> str:
    checksum = data
    while len(checksum) % 2 == 0:
        new_checksum = ''
        for i in range(0, len(checksum), 2):
            new_checksum += '1' if checksum[i] == checksum[i + 1] else '0'
        checksum = new_checksum
    return checksum

if __name__ == '__main__':
    input_str = '11011110011011101'

    data1 = generate_dragon_curve_data(input_str, 272)
    print(f'Part 1: {compute_checksum(data1)}')

    data2 = generate_dragon_curve_data(input_str, 35651584)
    print(f'Part 2: {compute_checksum(data2)}')
