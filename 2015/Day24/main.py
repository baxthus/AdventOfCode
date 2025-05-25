from itertools import combinations
import sys
import math
from typing import List, Optional


def read_input() -> List[int]:
    weights: List[int] = []
    for line in sys.stdin:
        stripped_line = line.strip()
        if stripped_line:
            weights.append(int(stripped_line))
    return weights

def calculate_quantum_entanglement(group: List[int]) -> int:
    if not group:
        return 1 # Consistent with std::accumulate with 1LL
    return math.prod(group)

def find_combination(
    weights: List[int],
    target_weight: int,
    group_size: int,
    current_combination: List[int], # Mutated during recursion
    start_index: int,
    current_sum: int,
) -> Optional[List[int]]: # Returns a new list if found, or None
    # Pruning: if current sum already exceeds target (assuming positive weights)
    # or if we've added too many items already (though len check handles this)
    if current_sum > target_weight:
        return None

    # Base case: combination is of the correct size
    if len(current_combination) == group_size:
        if current_sum == target_weight:
            return list(current_combination) # Found a valid combination, return a copy
        return None # Correct size, but sum is wrong

    # Pruning: if it's impossible to reach group_size with remaining elements
    # Elements needed: group_size - len(current_combination)
    # Elements available: len(weights) - start_index
    if (len(weights) - start_index) < (group_size - len(current_combination)):
        return None

    # Recursive step: try adding next compile
    for i in range(start_index, len(weights)):
        # Further pruning: if adding this element would make sum too large,
        # and we still need more elements, this path might be invalid
        # (More effetive if weights are sorted, but not assumed here)
        if current_sum + weights[i] > target_weight and len(current_combination) < group_size -1:
            # If adding weights[i] makes current_sum exceed target_weight,
            # and we are not at the point of picking the last element for the group,
            # then this specific weights[i] might be too large if others elements are also positive
            # However, without sorted weights, we must continue trying other elements at index i
            pass

        current_combination.append(weights[i])

        found_combo = find_combination(
            weights,
            target_weight,
            group_size,
            current_combination,
            i + 1,
            current_sum + weights[i],
        )

        current_combination.pop() # Backtrack

        if found_combo: # If a deeper call found a solution, propagete it up immediately
            return found_combo

    return None # No combination found from this path

def find_first_combination_for_size(
    weights: List[int],
    target_weight: int,
    group_size: int,
) -> Optional[List[int]]:
    current_combination_tracker: List[int] = [] # Initial empty list for the recursive helper
    return find_combination(
        weights,
        target_weight,
        group_size,
        current_combination_tracker,
        0,
        0,
    )

def find_ideal_quantum_entanglement(weights: List[int], num_groups: int) -> Optional[int]:
    if num_groups <= 0:
        return None

    total_weight = sum(weights)
    if total_weight % num_groups != 0:
        return None

    target_weight = total_weight // num_groups

    # If target_weight is 0:
    # - If weights is empty, QE=1 (empty group)
    # - If weights contains positive numbers, impossible to num to 0 with group_size >= 1
    # - If weights contains zeros, a group of [0] has QE=0
    # The logic below handles these cases by attempting to find combinations
    if target_weight < 0 and any(w > 0 for w in weights):
        return None

    if target_weight == 0:
        if not weights: # No items, target is 0. Loop for group_size won't run
            pass # Will correctly return None as loop for group_size >= 1 won't find solution
        elif all(w > 0 for w in weights): # All items are positive, can't sum to 0
            return None

    n = len(weights)
    # Max possible size for the first group is n / num_groups
    # Iterate group_size from 1 up to this limit
    # (n // num_groups) ensures integer division
    # If n < num_groups, then n // num_groups is 0, range(1, 1) is empty, loop doesn't run
    for group_size in range(1, (n // num_groups) + 1):
        combination = find_first_combination_for_size(weights, target_weight, group_size)
        if combination:
            return calculate_quantum_entanglement(combination)

    return None # No suitable combination found

if __name__ == '__main__':
    weights = read_input()

    if not weights:
        raise ValueError("No weights provided")

    print(f'Part 1: {find_ideal_quantum_entanglement(weights, 3)}')
    print(f'Part 2: {find_ideal_quantum_entanglement(weights, 4)}')
