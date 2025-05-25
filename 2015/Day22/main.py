from dataclasses import dataclass, field
from typing import List
import heapq
import sys

MAGIC_MISSILE = 0
DRAIN = 1
SHIELD = 2
POISON = 3
RECHARGE = 4

SPELL_COST = [53, 73, 113, 173, 229]

@dataclass(order=True)
class GameState:
    spent_mana: int
    player_hp: int
    player_mana: int
    boss_hp: int
    boss_damage: int
    shield_timer: int = 0
    poison_timer: int = 0
    recharge_timer: int = 0
    # field is needed for mutable default values
    spell_cast: List[int] = field(default_factory=list)

def simulate_battle(boss_hp: int, boss_damage: int, hard_mode: bool = False) -> float:
    # Priority queue stores tuples; we'll store (spent_mana, GameState_object)
    # but GameState itself is orderable by spent_mana due to @dataclass(order=True)
    # and the first field being spent_mana
    # Python's heapq is a min-head, so it works directly like std::greater for this
    pq: List[GameState] = []
    heapq.heappush(pq, GameState(
        spent_mana=0,
        player_hp=50,
        player_mana=500,
        boss_hp=boss_hp,
        boss_damage=boss_damage,
    ))

    min_mana_to_win = float('inf')
    # Keep track of visited states to avoid cycles and redundant computations
    # A state is defined by (player_hp, player_mana, boss_hp, shield_timer, poison_timer, recharge_timer)
    # We store the min_mana spent to reach that state
    visited_states = {}

    while pq:
        current = heapq.heappop(pq)

        if current.spent_mana >= min_mana_to_win:
            continue

        # Apply hard mode effect (player loses 1 HP at the start of their turn)
        if hard_mode:
            current.player_hp -= 1
            if current.player_hp <= 0:
                continue

        # Player's turn
        player_armor = 0
        if current.shield_timer > 0:
            player_armor = 7 # Shield effect
            current.shield_timer -= 1
        if current.poison_timer > 0:
            current.boss_hp -= 3
            current.poison_timer -= 1
        if current.recharge_timer > 0:
            current.player_mana += 101
            current.recharge_timer -= 1

        if current.boss_hp <= 0:
            min_mana_to_win = min(min_mana_to_win, current.spent_mana)
            continue

        for spell in range(5):
            if current.player_mana < SPELL_COST[spell]:
                continue

            if (spell == SHIELD and current.shield_timer > 0) or \
               (spell == POISON and current.poison_timer > 0) or \
               (spell == RECHARGE and current.recharge_timer > 0):
                continue

            next_turn_state = GameState(
                spent_mana=current.spent_mana + SPELL_COST[spell],
                player_hp=current.player_hp,
                player_mana=current.player_mana - SPELL_COST[spell],
                boss_hp=current.boss_hp,
                boss_damage=current.boss_damage,
                shield_timer=current.shield_timer,
                poison_timer=current.poison_timer,
                recharge_timer=current.recharge_timer,
                spell_cast=current.spell_cast + [spell]
            )

            if next_turn_state.spent_mana >= min_mana_to_win:
                continue

            if spell == MAGIC_MISSILE:
                next_turn_state.boss_hp -= 4
            elif spell == DRAIN:
                next_turn_state.boss_hp -= 2
                next_turn_state.player_hp += 2
            elif spell == SHIELD:
                next_turn_state.shield_timer = 6
            elif spell == POISON:
                next_turn_state.poison_timer = 6
            elif spell == RECHARGE:
                next_turn_state.recharge_timer = 5

            if next_turn_state.boss_hp <= 0:
                min_mana_to_win = min(min_mana_to_win, next_turn_state.spent_mana)
                continue

            # Boss's turn
            boss_turn_player_armor = 0
            if next_turn_state.shield_timer > 0:
                boss_turn_player_armor = 7
                next_turn_state.shield_timer -= 1 # Effect wears off
            if next_turn_state.poison_timer > 0:
                next_turn_state.boss_hp -= 3
                next_turn_state.poison_timer -= 1 # Effect wears off
            if next_turn_state.recharge_timer > 0:
                next_turn_state.player_mana += 101
                next_turn_state.recharge_timer -= 1 # Effect wears off

            if next_turn_state.boss_hp <= 0:
                min_mana_to_win = min(min_mana_to_win, next_turn_state.spent_mana)
                continue

            damage_to_player = next_turn_state.boss_damage - boss_turn_player_armor
            next_turn_state.player_hp -= damage_to_player

            if next_turn_state.player_hp > 0:
                state_key = (
                    next_turn_state.player_hp,
                    next_turn_state.player_mana,
                    next_turn_state.boss_hp,
                    next_turn_state.shield_timer,
                    next_turn_state.poison_timer,
                    next_turn_state.recharge_timer
                )
                if next_turn_state.spent_mana < visited_states.get(state_key, float('inf')):
                    visited_states[state_key] = next_turn_state.spent_mana
                    heapq.heappush(pq, next_turn_state)


    return min_mana_to_win if min_mana_to_win != float('inf') else -1

def main():
    lines = sys.stdin.read().strip().splitlines()
    boss_hp = int(lines[0].split(': ')[1])
    boss_damage = int(lines[1].split(': ')[1])

    print(f'Part 1: {simulate_battle(boss_hp, boss_damage)}')
    print(f'Part 2: {simulate_battle(boss_hp, boss_damage, hard_mode=True)}')

if __name__ == '__main__':
    main()
