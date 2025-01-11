import 'dart:io';

import 'package:collection/collection.dart';

class GameState implements Comparable<GameState> {
  int playerHp;
  int playerMana;
  int bossHp;
  int bossDamage;
  int shieldTimer;
  int poisonTimer;
  int rechargeTimer;
  int spentMana;
  List<int> spellCast;

  GameState(this.playerHp, this.playerMana, this.bossHp, this.bossDamage,
      this.shieldTimer, this.poisonTimer, this.rechargeTimer, this.spentMana,
      [this.spellCast = const []]);

  @override
  int compareTo(GameState other) {
    return spentMana.compareTo(other.spentMana);
  }
}

const int magicMissile = 0;
const int drain = 1;
const int shield = 2;
const int poison = 3;
const int recharge = 4;

const List<int> spellCost = [53, 73, 113, 173, 229];

int simulateBattle(int bossHp, int bossDamage, {bool hardMode = false}) {
  var pq = PriorityQueue<GameState>();
  pq.add(GameState(50, 500, bossHp, bossDamage, 0, 0, 0, 0));

  while (pq.isNotEmpty) {
    GameState current = pq.removeFirst();

    if (hardMode) {
      current.playerHp--;
      if (current.playerHp <= 0) continue;
    }

    if (current.shieldTimer > 0) current.shieldTimer--;
    if (current.poisonTimer > 0) {
      current.bossHp -= 3;
      current.poisonTimer--;
    }
    if (current.rechargeTimer > 0) {
      current.playerMana += 101;
      current.rechargeTimer--;
    }

    if (current.bossHp <= 0) return current.spentMana;

    for (int spell = 0; spell < 5; spell++) {
      if (current.playerMana < spellCost[spell]) continue;
      if ((spell == shield && current.shieldTimer > 0) ||
          (spell == poison && current.poisonTimer > 0) ||
          (spell == recharge && current.rechargeTimer > 0)) {
        continue;
      }

      var next = GameState(
          current.playerHp,
          current.playerMana - spellCost[spell],
          current.bossHp,
          current.bossDamage,
          current.shieldTimer,
          current.poisonTimer,
          current.rechargeTimer,
          current.spentMana + spellCost[spell],
          List<int>.from(current.spellCast)..add(spell));

      switch (spell) {
        case magicMissile:
          next.bossHp -= 4;
          break;
        case drain:
          next.bossHp -= 2;
          next.playerHp += 2;
          break;
        case shield:
          next.shieldTimer = 6;
          break;
        case poison:
          next.poisonTimer = 6;
          break;
        case recharge:
          next.rechargeTimer = 5;
          break;
      }

      if (next.bossHp <= 0) return next.spentMana;

      // boss turn
      if (next.shieldTimer > 0) next.shieldTimer--;
      if (next.poisonTimer > 0) {
        next.bossHp -= 3;
        next.poisonTimer--;
      }
      if (next.rechargeTimer > 0) {
        next.playerMana += 101;
        next.rechargeTimer--;
      }

      if (next.bossHp <= 0) return next.spentMana;

      int damage = next.bossDamage - (next.shieldTimer > 0 ? 7 : 0);
      next.playerHp -= damage > 0 ? damage : 1;

      if (next.playerHp > 0) pq.add(next);
    }
  }

  return -1;
}

void main() {
  final input = File('../input.txt').readAsLinesSync();
  final bossHp = int.parse(input[0].split(' ').last);
  final bossDamage = int.parse(input[1].split(' ').last);

  print('Part 1: ${simulateBattle(bossHp, bossDamage)}');
  print('Part 2: ${simulateBattle(bossHp, bossDamage, hardMode: true)}');
}
