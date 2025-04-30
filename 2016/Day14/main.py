import hashlib
import re
from functools import lru_cache

def calculate_md5(input_string):
  return hashlib.md5(input_string.encode('utf-8')).hexdigest()

def calculate_stretched_md5(input_string):
  hash_val = calculate_md5(input_string)
  for _ in range(2016):
    hash_val = calculate_md5(hash_val)
  return hash_val

TRIPLET_REGEX = re.compile(r'(.)\1\1')

def find_first_triplet_char(hash_str):
  match = TRIPLET_REGEX.search(hash_str)
  return match.group(1) if match else None

def has_quintuplet(hash_str, char):
  return (char * 5) in hash_str

def find_keys(salt, num_keys, hash_function):
  index = 0
  keys_found = 0
  @lru_cache(maxsize=2000)
  def get_hash(i):
    return hash_function(salt + str(i))

  while keys_found < num_keys:
    current_hash = get_hash(index)
    triplet_char = find_first_triplet_char(current_hash)

    if triplet_char:
      for i in range(index + 1, index + 1001):
        next_hash = get_hash(i)
        if has_quintuplet(next_hash, triplet_char):
          keys_found += 1
          if keys_found == num_keys:
            return index
          break

    index += 1

  return -1

if __name__ == "__main__":
  SALT = "zpqevtbw"
  NUM_KEYS_TO_FIND = 64

  print(f"Index of the 64th key: {find_keys(SALT, NUM_KEYS_TO_FIND, calculate_md5)}")
  print(f"Index of the 64th key with stretched hash: {find_keys(SALT, NUM_KEYS_TO_FIND, calculate_stretched_md5)}")
