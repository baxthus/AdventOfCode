from itertools import permutations

def parse_input(filename):
    happiness = {}
    people = set()
    with open(filename) as file:
        for line in file:
            parts = line.strip().split()
            person1 = parts[0]
            person2 = parts[-1][:-1]
            value = int(parts[3])
            if (parts[2] == "lose"):
                value = -value
            happiness[(person1, person2)] = value
            people.add(person1)
    return happiness, list(people)

def parse_input2(filename):
    happiness = {}
    people = set()
    with open(filename) as file:
        for line in file:
            parts = line.strip().split()
            person1 = parts[0]
            person2 = parts[-1][:-1]
            value = int(parts[3])
            if (parts[2] == "lose"):
                value = -value
            happiness[(person1, person2)] = value
            people.add(person1)

    you = "You"
    for person in people:
        happiness[(you, person)] = 0
        happiness[(person, you)] = 0
    people.add(you)

    return happiness, list(people)

def calculate_happiness(arrangement, happiness):
    total = 0
    n = len(arrangement)
    for i in range(n):
        person = arrangement[i]
        left = arrangement[(i - 1) % n]
        right = arrangement[(i + 1) % n]
        total += happiness.get((person, left), 0)
        total += happiness.get((person, right), 0)
    return total

def find_optimal_arrangement(happiness, people):
    max_happiness = float("-inf")
    for arrangement in permutations(people[1:]):
        arrangement = (people[0],) + arrangement
        current_happiness = calculate_happiness(arrangement, happiness)
        max_happiness = max(max_happiness, current_happiness)
    return max_happiness

happiness, people = parse_input("input.txt")
happiness2, people2 = parse_input2("input.txt")
print(f'Part 1: {find_optimal_arrangement(happiness, people)}')
print(f'Part 2: {find_optimal_arrangement(happiness2, people2)}')