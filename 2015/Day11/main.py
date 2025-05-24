def contains_invalid_characters(password):
    return 'i' in password or 'l' in password or 'o' in password

def has_straight(password):
    for i in range(len(password) - 2):
        if ord(password[i]) + 1 == ord(password[i + 1]) and ord(password[i]) + 2 == ord(password[i + 2]):
            return True
    return False

def has_two_pairs(password):
    pairs = 0
    i = 0
    while i < len(password) - 1:
        if password[i] == password[i+1]:
            pairs += 1
            i += 2
        else:
            i += 1
    return pairs >= 2

def increment_password(password):
    code_units = list(password)
    for i in range(len(code_units) - 1, -1, -1):
        if code_units[i] == 'z':
            code_units[i] = 'a'
        else:
            code_units[i] = chr(ord(code_units[i]) + 1)
            break
    return "".join(code_units)

def find_next_password(password):
    while True:
        password = increment_password(password)
        if not contains_invalid_characters(password) and has_straight(password) and has_two_pairs(password):
            break
    return password

if __name__ == '__main__':
    input_password = 'hxbxwxba'
    password1 = find_next_password(input_password)
    print(f'Part 1: {password1}')
    password2 = find_next_password(password1)
    print(f'Part 2: {password2}')
