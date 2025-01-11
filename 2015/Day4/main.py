import hashlib

def find_lowest_number(input):
    number = 1
    while True:
        hash_input = f'{input}{number}'.encode()
        hash = hashlib.md5(hash_input).hexdigest()
        if hash.startswith('00000'):
            return number
        number += 1

def find_lowest_number_six_zeroes(input):
    number = 1
    while True:
        hash_input = f'{input}{number}'.encode()
        hash = hashlib.md5(hash_input).hexdigest()
        if hash.startswith('000000'):
            return number
        number += 1

input = 'iwrupvqb'

print(f'Part 1: {find_lowest_number(input)}')
print(f'Part 2: {find_lowest_number_six_zeroes(input)}')
