def look_and_say(input_str):
    result = []
    count = 1
    for i in range(1, len(input_str) + 1):
        if i < len(input_str) and input_str[i] == input_str[i - 1]:
            count += 1
        else:
            result.append(str(count))
            result.append(input_str[i - 1])
            count = 1
    return "".join(result)

input_str = "3113322113"

for _ in range(40):
    input_str = look_and_say(input_str)

print(f"Part 1: {len(input_str)}")

for _ in range(10):
    input_str = look_and_say(input_str)

print(f"Part 2: {len(input_str)}")
