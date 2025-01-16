import 'dart:io';
import 'dart:math';

void main() async {
  var lines = await File('input.txt').readAsLines();
  var bossHp = int.parse(lines[0].split(': ')[1]);
  var bossDamage = int.parse(lines[1].split(': ')[1]);
  var bossArmor = int.parse(lines[2].split(': ')[1]);

  print('Part 1: ${findLeastGoldToWin(bossHp, bossDamage, bossArmor)}');
  print('Part 2: ${findMostGoldToLose(bossHp, bossDamage, bossArmor)}');
}

List<Item> armors = [
  Item('No Armor', 0, 0, 0),
  Item('Leather', 13, 0, 1),
  Item('Chainmail', 31, 0, 2),
  Item('Splintmail', 53, 0, 3),
  Item('Bandedmail', 75, 0, 4),
  Item('Platemail', 102, 0, 5)
];

List<Item> rings = [
  Item('No Ring', 0, 0, 0),
  Item('Damage +1', 25, 1, 0),
  Item('Damage +2', 50, 2, 0),
  Item('Damage +3', 100, 3, 0),
  Item('Defense +1', 20, 0, 1),
  Item('Defense +2', 40, 0, 2),
  Item('Defense +3', 80, 0, 3)
];

List<Item> weapons = [
  Item('Dagger', 8, 4, 0),
  Item('Shortsword', 10, 5, 0),
  Item('Warhammer', 25, 6, 0),
  Item('Longsword', 40, 7, 0),
  Item('Greataxe', 74, 8, 0)
];

int findLeastGoldToWin(int bossHp, int bossDamage, int bossArmor) {
  int minGold = 1000000;
  for (var weapon in weapons) {
    for (var armor in armors) {
      for (int i = 0; i < rings.length; ++i) {
        for (int j = i; j < rings.length; ++j) {
          var ring1 = rings[i];
          var ring2 = rings[j];
          int gold = weapon.cost + armor.cost + ring1.cost + ring2.cost;
          int damage =
              weapon.damage + armor.damage + ring1.damage + ring2.damage;
          int defense = weapon.armor + armor.armor + ring1.armor + ring2.armor;

          if (simulateBattle(
              100, damage, defense, bossHp, bossDamage, bossArmor)) {
            minGold = min(minGold, gold);
          }
        }
      }
    }
  }

  return minGold;
}

int findMostGoldToLose(int bossHp, int bossDamage, int bossArmor) {
  int maxGold = 0;
  for (var weapon in weapons) {
    for (var armor in armors) {
      for (int i = 0; i < rings.length; ++i) {
        for (int j = i; j < rings.length; ++j) {
          var ring1 = rings[i];
          var ring2 = rings[j];

          if (i == j && ring1.name != 'No Ring') continue;

          int gold = weapon.cost + armor.cost + ring1.cost + ring2.cost;
          int damage =
              weapon.damage + armor.damage + ring1.damage + ring2.damage;
          int defense = weapon.armor + armor.armor + ring1.armor + ring2.armor;

          if (!simulateBattle(
              100, damage, defense, bossHp, bossDamage, bossArmor)) {
            maxGold = max(maxGold, gold);
          }
        }
      }
    }
  }

  return maxGold;
}

bool simulateBattle(int playerHp, int playerDamage, int playerArmor, int bossHp,
    int bossDamage, int bossArmor) {
  while (true) {
    bossHp -= max(1, playerDamage - bossArmor);
    if (bossHp <= 0) return true;
    playerHp -= max(1, bossDamage - playerArmor);
    if (playerHp <= 0) return false;
  }
}

class Item {
  final String name;
  final int cost;
  final int damage;
  final int armor;

  Item(this.name, this.cost, this.damage, this.armor);
}
