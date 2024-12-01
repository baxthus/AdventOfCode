import re

def is_nice_string(s):
    vowels = 'aeiou'
    disallowed = ['ab', 'cd', 'pq', 'xy']
    vowel_count = sum(1 for chat in s if chat in vowels)
    has_double_letter = any(s[i] == s[i-1] for i in range(1, len(s)))
    contains_disallowed = any(dis in s for dis in disallowed)
    return vowel_count >= 3 and has_double_letter and not contains_disallowed

def is_nice_string2(s):
    has_repeating_pair = bool(re.search(r'(..).*\1', s))
    has_repeating_letter_with_one_between = bool(re.search(r'(.).\1', s))
    return has_repeating_pair and has_repeating_letter_with_one_between

def count_nice_strings(strings, function):
    return sum(1 for s in strings if function(s))

with open('input.txt', 'r') as file:
    strings = file.read().splitlines()

print(f"Part 1: {count_nice_strings(strings, is_nice_string)}")
print(f"Part 2: {count_nice_strings(strings, is_nice_string2)}")