import re

def parse_input(filename):
    aunts = {}
    with open(filename, 'r') as file:
        for line in file:
            match = re.match(r'Sue (\d+): (.*)', line.strip())
            if match:
                sue_member = int(match.group(1))
                attributes = match.group(2).split(', ')
                aunt_data = {}
                for attr in attributes:
                    key, value = attr.split(': ')
                    aunt_data[key] = int(value)
                aunts[sue_member] = aunt_data
    return aunts

def find_matching_sue(aunts, mfcsam_reading):
    for sue, attributes in aunts.items():
        if all(mfcsam_reading[attr] == value for attr, value in attributes.items()):
            return sue
    return None

def match_attribute(attr, value, mfcsam_value):
    if attr in ['cats', 'trees']:
        return value > mfcsam_value if mfcsam_value is not None else True
    elif attr in ['pomeranians', 'goldfish']:
        return value < mfcsam_value if mfcsam_value is not None else True
    else:
        return value == mfcsam_value if mfcsam_value is not None else True

def find_real_sue(aunts, mfcsam_reading):
    for sue, attributes in aunts.items():
        if all(match_attribute(attr, value, mfcsam_reading.get(attr)) for attr, value in attributes.items()):
            return sue
    return None

mfcsam_reading = {
    'children': 3,
    'cats': 7,
    'samoyeds': 2,
    'pomeranians': 3,
    'akitas': 0,
    'vizslas': 0,
    'goldfish': 5,
    'trees': 3,
    'cars': 2,
    'perfumes': 1
}

aunts = parse_input('input.txt')

print(f"Part 1: {find_matching_sue(aunts, mfcsam_reading)}")
print(f"Part 2: {find_real_sue(aunts, mfcsam_reading)}")