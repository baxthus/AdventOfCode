from itertools import combinations

weapons = [
    ("Dagger", 8, 4, 0),
    ("Shortsword", 10, 5, 0),
    ("Warhammer", 25, 6, 0),
    ("Longsword", 40, 7, 0),
    ("Greataxe", 74, 8, 0)
]
armors = [
    ("No Armor", 0, 0, 0),
    ("Leather", 13, 0, 1),
    ("Chainmail", 31, 0, 2),
    ("Splintmail", 53, 0, 3),
    ("Bandedmail", 75, 0, 4),
    ("Platemail", 102, 0, 5)
]
rings = [
    ("No Ring", 0, 0, 0),
    ("Damage +1", 25, 1, 0),
    ("Damage +2", 50, 2, 0),
    ("Damage +3", 100, 3, 0),
    ("Defense +1", 20, 0, 1),
    ("Defense +2", 40, 0, 2),
    ("Defense +3", 80, 0, 3)
]

def simulate_battle(player_hp, player_damage, player_armor, boss_hp, boss_damage, boss_armor):
    while True:
        boss_hp -= max(1, player_damage - boss_armor)
        if boss_hp <= 0:
            return True
        player_hp -= max(1, boss_damage - player_armor)
        if player_hp <= 0:
            return False

def find_least_gold_to_win(boss_hp, boss_damage, boss_armor):
    min_gold = float("inf")
    for weapon in weapons:
        for armor in armors:
            for ring1, ring2 in combinations(rings, 2):
                gold = weapon[1] + armor[1] + ring1[1] + ring2[1]
                damage = weapon[2] + armor[2] + ring1[2] + ring2[2]
                defense = weapon[3] + armor[3] + ring1[3] + ring2[3]

                if simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor):
                    min_gold = min(min_gold, gold)
    return min_gold

def find_most_gold_to_lose(boss_hp, boss_damage, boss_armor):
    max_gold = 0
    for weapon in weapons:
        for armor in armors:
            for ring1, ring2 in combinations(rings, 2):
                if ring1[0] == ring2[0] and ring1[0].startswith("No Ring"):
                    continue
                gold = weapon[1] + armor[1] + ring1[1] + ring2[1]
                damage = weapon[2] + armor[2] + ring1[2] + ring2[2]
                defense = weapon[3] + armor[3] + ring1[3] + ring2[3]

                if not simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor):
                    max_gold = max(max_gold, gold)
    return max_gold

with open("input.txt", "r") as file:
    boss_hp = int(file.readline().split(': ')[1])
    boss_damage = int(file.readline().split(': ')[1])
    boss_armor = int(file.readline().split(': ')[1])

print(f"Part 1: {find_least_gold_to_win(boss_hp, boss_damage, boss_armor)}")
print(f"Part 2: {find_most_gold_to_lose(boss_hp, boss_damage, boss_armor)}")