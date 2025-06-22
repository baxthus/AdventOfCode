int part1(int numElves) {
  int highestPowerOf2 = 1 << (numElves.bitLength - 1);
  int l = numElves - highestPowerOf2;
  return 2 * l + 1;
}

int part2(int numElves) {
  int p3 = 1;
  while (p3 * 3 <= numElves) {
    p3 *= 3;
  }

  if (numElves == p3)
    return numElves;
  else if (numElves <= 2 * p3)
    return numElves - p3;
  else
    return 2 * numElves - 3 * p3;
}

void main() {
  const numElves = 3017957;

  print('Part 1: ${part1(numElves)}');
  print('Part 2: ${part2(numElves)}');
}
