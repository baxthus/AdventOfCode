#include <cmath>
#include <fstream>
#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct GameState {
  int player_hp;
  int player_mana;
  int boss_hp;
  int boss_damage;
  int shield_timer;
  int poison_timer;
  int recharge_timer;
  int spent_mana;
  std::vector<int> spell_cast;

  bool operator>(const GameState &other) const {
    return spent_mana > other.spent_mana;
  }
};

const int MAGIC_MISSILE = 0;
const int DRAIN = 1;
const int SHIELD = 2;
const int POISON = 3;
const int RECHARGE = 4;

const int spell_cost[] = {53, 73, 113, 173, 229};

int simulate_battle(int boss_hp, int boss_damage, bool hard_mode = false) {
  std::priority_queue<GameState, std::vector<GameState>,
                      std::greater<GameState>>
      pq;
  pq.push({50, 500, boss_hp, boss_damage, 0, 0, 0, 0});

  while (!pq.empty()) {
    GameState current = pq.top();
    pq.pop();

    if (hard_mode) {
      current.player_hp--;
      if (current.player_hp <= 0)
        continue;
    }

    if (current.shield_timer > 0)
      current.shield_timer--;
    if (current.poison_timer > 0) {
      current.boss_hp -= 3;
      current.poison_timer--;
    }
    if (current.recharge_timer > 0) {
      current.player_mana += 101;
      current.recharge_timer--;
    }

    if (current.boss_hp <= 0)
      return current.spent_mana;

    for (int spell = 0; spell < 5; spell++) {
      if (current.player_mana < spell_cost[spell])
        continue;
      if ((spell == SHIELD && current.shield_timer > 0) ||
          (spell == POISON && current.poison_timer > 0) ||
          (spell == RECHARGE && current.recharge_timer > 0))
        continue;

      GameState next = current;
      next.player_mana -= spell_cost[spell];
      next.spent_mana += spell_cost[spell];
      next.spell_cast.push_back(spell);

      switch (spell) {
      case MAGIC_MISSILE:
        next.boss_hp -= 4;
        break;
      case DRAIN:
        next.boss_hp -= 2;
        next.player_hp += 2;
        break;
      case SHIELD:
        next.shield_timer = 6;
        break;
      case POISON:
        next.poison_timer = 6;
        break;
      case RECHARGE:
        next.recharge_timer = 5;
        break;
      }

      if (next.boss_hp <= 0)
        return next.spent_mana;

      // boss turn
      if (next.shield_timer > 0)
        next.shield_timer--;
      if (next.poison_timer > 0) {
        next.boss_hp -= 3;
        next.poison_timer--;
      }
      if (next.recharge_timer > 0) {
        next.player_mana += 101;
        next.recharge_timer--;
      }

      if (next.boss_hp <= 0)
        return next.spent_mana;

      int damage = next.boss_damage - (next.shield_timer > 0 ? 7 : 0);
      next.player_hp -= std::max(damage, 1);

      if (next.player_hp > 0)
        pq.push(next);
    }
  };

  return -1;
}

int main() {
  std::ifstream input{"input.txt"};
  std::string dummy;
  int boss_hp, boss_damage;
  input >> dummy >> dummy >> boss_hp;
  input >> dummy >> boss_damage;

  std::cout << "Part 1: " << simulate_battle(boss_hp, boss_damage) << std::endl;
  std::cout << "Part 2: " << simulate_battle(boss_hp, boss_damage, true)
            << std::endl;

  return 0;
}
