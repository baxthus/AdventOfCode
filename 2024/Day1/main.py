def calculate_total_distance(input_text):
    left_list = []
    right_list = []

    for line in input_text.split('\n'):
        if line.strip():
            left, right = map(int, line.split())
            left_list.append(left)
            right_list.append(right)
    
    left_list.sort()
    right_list.sort()

    total_distance = sum(abs(a - b) for a, b in zip(left_list, right_list))
    return total_distance

def calculate_similarity_score(input_text):
    left_list = []
    right_list = []

    for line in input_text.split('\n'):
        if line.strip():
            left, right = map(int, line.split())
            left_list.append(left)
            right_list.append(right)
        
    right_counts = {}
    for num in right_list:
        right_counts[num] = right_counts.get(num, 0) + 1

    similarity_score = sum(num * right_counts.get(num, 0) for num in left_list)
    return similarity_score

with open('input.txt', 'r') as file:
    input_text = file.read()

print(f"The total distance is {calculate_total_distance(input_text)}")
print(f"The similarity score is {calculate_similarity_score(input_text)}")