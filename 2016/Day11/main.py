import sys
import re
from collections import deque
from typing import Dict, List, Set, Tuple
import itertools


class State:
    def __init__(self, elevator: int, items: List[Tuple[int, int]], steps: int):
        self.elevator = elevator # Current floor of the elevator (1-4)
        self.items = items # List of (generator_floor, chip_floor) for each element type
        self.steps = steps

    def get_hash(self) -> str:
        # Sort items to ensure canonical representation for the visited set
        # Items are (generator_floor, chip_floor) tuples
        sorted_items = sorted(self.items)
        hash_str = f'{self.elevator}-'
        for gen_floor, chip_floor in sorted_items:
            hash_str += f'{gen_floor},{chip_floor};'
        return hash_str

    def is_valid(self) -> bool:
        for i in range(len(self.items)):
            gen_i_floor, chip_i_floor = self.items[i]

            if gen_i_floor == chip_i_floor:
                continue # Chip i is with its generator, safe

            # Chip i is not with its generator
            # Check if any other generator (from any element j) is on chip_i_floor
            for j in range(len(self.items)):
                gen_j_floor, _ = self.items[j]
                if gen_j_floor == chip_i_floor:
                    # Generator j is on the same floor as chip i,
                    # and chip i is not with its own generator i
                    # This means chip i is fried
                    return False
        return True

    def is_goal(self) -> bool:
        # All items must be on the 4th floor
        for gen_floor, chip_floor in self.items:
            if gen_floor != 4 or chip_floor != 4:
                return False
        return True

    # For debugging or direct use in sets if get_hash wasn't used for visited
    def __eq__(self, other: object) -> bool:
        if not isinstance(other, State):
            return NotImplemented
        return self.elevator == other.elevator and \
                sorted(self.items) == sorted(other.items) # steps don't define state uniqueness for visited

    def __hash__(self) -> int:
        # Consistent with get_hash for potential direct use in sets
        return hash(self.get_hash())

def get_next_states(current: State) -> List[State]:
    next_states: List[State] = []
    possible_floors: List[int] = []

    if current.elevator < 4:
        possible_floors.append(current.elevator + 1)
    if current.elevator > 1:
        possible_floors.append(current.elevator - 1)

    # (item_index, type_is_chip: bool)
    items_on_current_floor: List[Tuple[int, int]] = []
    for i in range(len(current.items)):
        gen_floor, chip_floor = current.items[i]
        if gen_floor == current.elevator:
            items_on_current_floor.append((i, False)) # False for generator
        if chip_floor == current.elevator:
            items_on_current_floor.append((i, True)) # True for chip

    # Try moving one item
    for item_to_move_tuple in items_on_current_floor:
        item_idx, item_is_chip = item_to_move_tuple
        for next_elevator_floor in possible_floors:
            new_items = list(current.items) # Create a mutable copy

            gen_floor, chip_floor = new_items[item_idx]
            if item_is_chip:
                new_items[item_idx] = (gen_floor, next_elevator_floor)
            else: # item is generator
                new_items[item_idx] = (next_elevator_floor, chip_floor)

            new_state = State(next_elevator_floor, new_items, current.steps + 1)
            if new_state.is_valid():
                next_states.append(new_state)

    # Try moving two items
    if len(items_on_current_floor) >= 2:
        for combo in itertools.combinations(items_on_current_floor, 2):
            item1_tuple, item2_tuple = combo
            item1_idx, item1_is_chip = item1_tuple
            item2_idx, item2_is_chip = item2_tuple

            for next_elevator_floor in possible_floors:
                new_items = list(current.items) # Create a mutable copy

                # Move item 1
                gen1_floor, chip1_floor = new_items[item1_idx]
                if item1_is_chip:
                    new_items[item1_idx] = (gen1_floor, next_elevator_floor)
                else:
                    new_items[item1_idx] = (next_elevator_floor, chip1_floor)

                # Move item 2
                # Need to read potentially updated new_items if item1_idx == item2_idx (not possible with combinations of distinct items)
                # or if item1 and item2 refer to parts of the same element pair (e.g. polonium gen and polonium chip)
                # The indices item1_idx and item2_idx are indices into the original items list
                # They refer to distinct element types if item1_idx != item2_idx
                # If item1_idx == item2_idx, it means we picked the generator and chip of the SAME element

                # Read from potentially modified list if item1_idx == item2_idx
                # This is fine because if item1_idx == item2_idx, one is gen, one is chip
                # The modification of item1 would have updated one part of the tuple
                # When we update item2, we use the correct original other part
                gen2_floor, chip2_floor = new_items[item2_idx]

                # If item1 and item2 are from the same element (e.g. moving polonium gen and polonium chip)
                # item1_idx == item2_idx
                # Example: current.items[idx] = (curr_elev, curr_elev)
                # item1 = (idx, False) -> gen, item2 = (idx, True) -> chip
                # After moving item1 (gen): new_items[idx] = (next_elev_floor, curr_elev)
                # For item2 (chip): gen2_floor is next_elev_floor, chip2_floor is curr_elev
                # We want to set chip to next_elev_floor
                # So, new_items[item2_idx] = (gen_part, chip_part)
                # gen_part should be new_items[item2_idx][0] and chip_part should be new_items[item2_idx][1]
                # before this specific item2 modification

                # Let's re-fetch the state of item2 from the list that was modified by item1's move
                # This ensures that if item1 and item2 are the generator and chip of the same element,
                # the update is based on the intermediate state
                current_gen_for_item2, current_chip_for_item2 = new_items[item2_idx]

                if item2_is_chip:
                    new_items[item2_idx] = (current_gen_for_item2, next_elevator_floor)
                else: # item2 is generator
                    new_items[item2_idx] = (next_elevator_floor, current_chip_for_item2)

                new_state = State(next_elevator_floor, new_items, current.steps + 1)
                if new_state.is_valid():
                    next_states.append(new_state)

    return next_states

def parse_input(lines: List[str], part2: bool = False) -> State:
    element_to_idx: Dict[str, int] = {}
    items_wip: List[List[int]] = [] # Store as [gen_floor, chip_floor], 0 if not found yet

    for floor_idx, line in enumerate(lines):
        current_floor = floor_idx + 1 # 1-indexed floors

        # Regex for generators: 'a (thulium) generator'
        gen_regex = r'a (\w+) generator'
        for match in re.finditer(gen_regex, line):
            element = match.group(1)
            if element not in element_to_idx:
                element_to_idx[element] = len(items_wip)
                items_wip.append([0, 0]) # [gen_floor, chip_floor]
            items_wip[element_to_idx[element]][0] = current_floor

        # Regex for microchips: 'a (thulium)-compatible microchip'
        chip_regex = r'a (\w+)-compatible microchip'
        for match in re.finditer(chip_regex, line):
            element = match.group(1)
            if element not in element_to_idx:
                element_to_idx[element] = len(items_wip)
                items_wip.append([0, 0]) # [gen_floor, chip_floor]
            items_wip[element_to_idx[element]][1] = current_floor

    final_items: List[Tuple[int, int]] = []
    for gen_f, chip_f in items_wip:
        if gen_f == 0 and chip_f == 0:
            # This case should ideally not happen if input is well-formed
            # and every mentioned element has at least one part2
            # If an element is mentioned (e.g. in element_to_idx) but never placed,
            # this could be an issue
            # For safety, if an element was named but its parts not found any floor,
            # it's ambiguous. Assuming valid input where all parts are placed
            # If a part is missing, its floor remains 0. This might be okay if
            # is_valid and is_goal handle floor 0 correctly (they assume 1-4)
            # The problem implies all items start on some floor 1-4
            pass # Or raise error, or assign a default?
        final_items.append((gen_f, chip_f))

    if part2:
        final_items.append((1, 1)) # Add elerium (gen+chip on floor 1)
        final_items.append((1, 1)) # Add dilithium (gen+chip on floor 1)

    return State(1, final_items, 0)

def find_minimum_steps(initial_state: State) -> int:
    queue: deque[State] = deque()
    visited_hashes: Set[str] = set()

    if not initial_state.is_valid():
        # This shouldn't happen with problem inputs but good check
        return -2 # Indicate invalid start

    queue.append(initial_state)
    visited_hashes.add(initial_state.get_hash())

    while queue:
        current = queue.popleft()

        if current.is_goal():
            return current.steps

        for next_state in get_next_states(current):
            next_hash = next_state.get_hash()
            if next_hash not in visited_hashes:
                visited_hashes.add(next_hash)
                queue.append(next_state)

    return -1 # Should not be reached if a solution exists

if __name__ == '__main__':
    lines = [line.strip() for line in sys.stdin.readlines()]

    initial_state1 = parse_input(lines)
    print(f'Minimum steps: {find_minimum_steps(initial_state1)}')
    initial_state2 = parse_input(lines, part2=True)
    print(f'Minimum steps with additional items: {find_minimum_steps(initial_state2)}')
