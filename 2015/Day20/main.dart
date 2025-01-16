void main() {
  const input = 34000000;

  print('Part 1: ${findLowestHouse(input)}');
  print('Part 2: ${findLowestHouse2(input)}');
}

int findLowestHouse(int targetPresents) {
  var maxHouses = (targetPresents / 10).ceil();
  var housePresents = List<int>.filled(maxHouses + 1, 0);

  for (var elf = 1; elf < housePresents.length; elf++) {
    for (var house = elf; house < housePresents.length; house += elf) {
      housePresents[house] += elf * 10;
    }
  }

  for (var houseNumber = 1; houseNumber < housePresents.length; houseNumber++) {
    if (housePresents[houseNumber] >= targetPresents) {
      return houseNumber;
    }
  }

  return -1; // No house found
}

int findLowestHouse2(int targetPresents) {
  var maxHouses = (targetPresents / 11).ceil();
  var housePresents = List<int>.filled(maxHouses + 1, 0);

  for (var elf = 1; elf < housePresents.length; elf++) {
    for (var house = elf;
        house < (elf * 50).clamp(0, housePresents.length);
        house += elf) {
      housePresents[house] += elf * 11;
    }
  }

  for (var houseNumber = 1; houseNumber < housePresents.length; houseNumber++) {
    if (housePresents[houseNumber] >= targetPresents) {
      return houseNumber;
    }
  }

  return -1; // No house found
}
