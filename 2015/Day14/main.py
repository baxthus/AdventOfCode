import re

def parse_reindeer(line):
    pattern = r'(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.'
    match = re.match(pattern, line)
    if match:
        name, speed, fly_time, rest_time = match.groups()
        return name, int(speed), int(fly_time), int(rest_time)
    return None

def calculate_distance(speed, fly_time, rest_time, total_time):
    cycle_time = fly_time + rest_time
    full_cycles = total_time // cycle_time
    remaining_time = total_time % cycle_time

    distance = full_cycles * fly_time * speed
    if remaining_time > fly_time:
        distance += fly_time * speed
    else:
        distance += remaining_time * speed

    return distance

def calculate_distance2(speed, fly_time, rest_time, current_time):
    cycle_time = fly_time + rest_time
    full_cycles = current_time // cycle_time
    remaining_time = current_time % cycle_time

    distance = full_cycles * fly_time * speed
    if remaining_time > fly_time:
        distance += fly_time * speed
    else:
        distance += remaining_time * speed

    return distance

def find_winning_reindeer(reindeer_list, total_time):
    max_distance = 0
    winner = None

    for reindeer in reindeer_list:
        name, speed, fly_time, rest_time = reindeer
        distance = calculate_distance(speed, fly_time, rest_time, total_time)
        if distance > max_distance:
            max_distance = distance
            winner = name

    return winner, max_distance

def simulate_race(reindeer_list, duration):
    points = {reindeer[0]: 0 for reindeer in reindeer_list}
    distances = {reindeer[0]: 0 for reindeer in reindeer_list}

    for second in range(1, duration + 1):
        for reindeer in reindeer_list:
            name, speed, fly_time, rest_time = reindeer
            if second % (fly_time + rest_time) <= fly_time and second % (fly_time + rest_time) != 0:
                distances[name] += speed

        max_distance = max(distances.values())
        for reindeer in reindeer_list:
            name = reindeer[0]
            if distances[name] == max_distance:
                points[name] += 1

    return points

with open('input.txt', 'r') as file:
    reindeer_data = file.readlines()

reindeer_list = [parse_reindeer(line) for line in reindeer_data]
winner, distance = find_winning_reindeer(reindeer_list, 2503)

points = simulate_race(reindeer_list, 2503)
race_winner = max(points.items(), key=lambda item: item[1])[0]
max_points = points[race_winner]

print(f'Part 1: {winner} won with a distance of {distance} km')
print(f'Part 2: {race_winner} won with {max_points} points')
