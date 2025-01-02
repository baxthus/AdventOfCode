import hashlib

def find_password(door_id):
    password = ""
    index = 0

    while len(password) < 8:
        to_hash = door_id + str(index)

        hash_result = hashlib.md5(to_hash.encode()).hexdigest()

        if hash_result.startswith("00000"):
            password += hash_result[5]

        index += 1

    return password

def find_password2(door_id):
    password = ['_'] * 8
    index = 0
    filled_positions = 0

    while filled_positions < 8:
        to_hash = door_id + str(index)

        hash_result = hashlib.md5(to_hash.encode()).hexdigest()

        if hash_result.startswith("00000"):
            position = hash_result[5]
            if position.isdigit():
                position = int(position)
                if position < 8 and password[position] == '_':
                    password[position] = hash_result[6]
                    filled_positions += 1

        index += 1

    return "".join(password)

door_id = "ojvtpuvg"

print(f"Part 1: {find_password(door_id)}")
print(f"Part 2: {find_password2(door_id)}")
