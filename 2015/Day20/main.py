def find_lowest_house(target_presents):
    house_presents = [0] * (target_presents // 10 + 1)
    for elf in range(1, len(house_presents)):
        for house in range(elf, len(house_presents), elf):
            house_presents[house] += elf * 10
    for house_number in range(1, len(house_presents)):
        if house_presents[house_number] >= target_presents:
            return house_number

def find_lowest_house2(target_presents):
    max_houses = target_presents // 11 + 1
    house_presents = [0] * max_houses
    for elf in range(1, len(house_presents)):
        for house in range(elf, min(elf * 50, len(house_presents)), elf):
            house_presents[house] += elf * 11
    for house_number in range(1, len(house_presents)):
        if house_presents[house_number] >= target_presents:
            return house_number

input = 34000000

print(f"Part 1: {find_lowest_house(input)}")
print(f"Part 2: {find_lowest_house2(input)}")