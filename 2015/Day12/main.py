import json

def sum_numbers_in_json(data):
    if isinstance(data, dict):
        return sum(sum_numbers_in_json(value) for value in data.values())
    elif isinstance(data, list):
        return sum(sum_numbers_in_json(value) for value in data)
    elif isinstance(data, int):
        return data
    return 0

def sum_numbers_in_json_without_red(data):
    if isinstance(data, dict):
        if "red" in data.values():
            return 0
        return sum(sum_numbers_in_json_without_red(value) for value in data.values())
    elif isinstance(data, list):
        return sum(sum_numbers_in_json_without_red(value) for value in data)
    elif isinstance(data, int):
        return data
    return 0

with open("input.txt", 'r') as file:
    json_data = json.load(file)


print(f"Part 1: {sum_numbers_in_json(json_data)}")
print(f"Part 2: {sum_numbers_in_json_without_red(json_data)}")