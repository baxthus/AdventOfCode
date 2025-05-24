from dataclasses import dataclass
import re
import sys
from typing import List

@dataclass
class Disc:
  id: int # Disc number (k)
  num_pos: int # Number of positions (N_k)
  start_pos: int # Starting position at time=0 (P_k)

def check_time(T: int, discs: List[Disc]) -> bool:
  for disc in discs:
    time_at_disc = T + disc.id
    position_at_time = (disc.start_pos + time_at_disc) % disc.num_pos
    if position_at_time != 0:
      return False
  return True

def find_first_valid_time(discs: List[Disc]) -> int:
  T = 0
  while True:
    if check_time(T, discs):
      return T
    T += 1

def main():
  discs: List[Disc] = []

  pattern = re.compile(r"Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)\.")

  max_id = 0

  for line in sys.stdin:
    line = line.strip()
    if not line:
      continue

    match = pattern.match(line)
    if match:
      id_num = int(match.group(1))
      num_pos = int(match.group(2))
      start_pos = int(match.group(3))
      discs.append(Disc(id_num, num_pos, start_pos))
      if id_num > max_id:
        max_id = id_num

  if not discs:
    print("No discs found.")
    return

  T1 = find_first_valid_time(discs)
  print(f"First time the capsule passes through all discs: {T1}")

  new_disc_id = max_id + 1
  new_disc_num_pos = 11
  new_disc_start_pos = 0
  discs.append(Disc(new_disc_id, new_disc_num_pos, new_disc_start_pos))

  T2 = find_first_valid_time(discs)
  print(f"First time the capsule passes through all discs (with new disc): {T2}")

if __name__ == "__main__":
  main()
