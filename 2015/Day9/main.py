import itertools

def parse_input(filename):
    distances = {}
    cities = set()
    with open(filename, 'r') as file:
        for line in file:
            parts = line.strip().split(' = ')
            if len(parts) == 2:
                route, distance = parts
                city1, city2 = route.split(' to ')
                distances[(city1, city2)] = int(distance)
                distances[(city2, city1)] = int(distance)
                cities.add(city1)
                cities.add(city2)
    return distances, cities

def calculate_route_distance(route, distance):
    return sum(distance[(route[i], route[i+1])] for i in range(len(route) - 1))

def find_shortest_route(distances, cities):
    shortest_distance = float('inf')
    for route in itertools.permutations(cities):
        distance = calculate_route_distance(route, distances)
        shortest_distance = min(shortest_distance, distance)
    return shortest_distance

def find_longest_route(distances, cities):
    longest_distance = float('-inf')
    for route in itertools.permutations(cities):
        distance = calculate_route_distance(route, distances)
        longest_distance = max(longest_distance, distance)
    return longest_distance

distances, cities = parse_input('input.txt')
print(f'Part 1: {find_shortest_route(distances, cities)}')
print(f'Part 2: {find_longest_route(distances, cities)}')