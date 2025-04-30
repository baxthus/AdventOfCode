// Represent a pair, similar to std::pair in C++
// Includes comparison logic for sorting
import 'dart:collection';
import 'dart:io';

class Pair<T1 extends Comparable, T2 extends Comparable>
    implements Comparable<Pair<T1, T2>> {
  T1 first;
  T2 second;

  Pair(this.first, this.second);

  @override
  int compareTo(Pair<T1, T2> other) {
    int cmp = first.compareTo(other.first);
    if (cmp != 0) return cmp;
    return second.compareTo(other.second);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() => '($first, $second)';
}

class State {
  final int elevator; // Current floor of the elevator
  // List of pairs: (generator_floor, chip_floor) for each element type
  // The index identifies the element type
  final List<Pair<int, int>> items;
  final int steps; // Number of steps taken to reach this state

  State(this.elevator, List<Pair<int, int>> items, this.steps)
    // Ensure immutability of items if needed,
    // although direct use is fine if we always create new lists for new states
    : items = List.unmodifiable(items);

  // Generates a unique hash for the state
  // Sorts items first so that the orders of elements doesn't affect the hash
  // This is important for the visited set
  String getHash() {
    var sortedItems = List<Pair<int, int>>.from(items);
    sortedItems.sort();

    var hash = StringBuffer();
    hash.write('$elevator-');
    for (final item in sortedItems) {
      hash.write('${item.first},${item.second};');
    }
    return hash.toString();
  }

  // Checks if the current state is valid according to the rules
  // A chip is fried if it's on the same floor as a generator of a *different* type,
  // and its own generator is not on the same floor
  bool isValid() {
    for (int i = 0; i < items.length; i++) {
      int chipFloor = items[i].second;
      int generatorFloor = items[i].first;

      // If chip is safe with its own generator, skip
      if (chipFloor == generatorFloor) continue;

      // Check if any *other* generator is on the same floor as the chip
      for (int j = 0; j < items.length; j++) {
        if (items[j].first == chipFloor) {
          // Found a generator on the same floor as the chip
          // Since we already know chipFloor != generatorFloor (from above),
          // this means the chip is fried
          return false;
        }
      }
    }

    // No fried chips found
    return true;
  }

  // Check if the goal state is reached (all items on floor 4)
  bool isGoal() {
    for (final item in items) {
      if (item.first != 4 || item.second != 4) return false;
    }
    return true;
  }

  // Use the hash representation for use in the visited set
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          getHash() == other.getHash();

  @override
  int get hashCode => getHash().hashCode;
}

// Generate all valid next states reachable from the current state
List<State> getNextStates(State current) {
  List<State> nextStates = [];
  List<int> possibleFloors = [];

  // Determine possible floors (up or down)
  if (current.elevator < 4) possibleFloors.add(current.elevator + 1);
  if (current.elevator > 1) possibleFloors.add(current.elevator - 1);

  // Identify items and their types currently on the same floor as the elevator
  // Stora as (item_index, type), where type 0=generator, 1=chip
  List<Pair<int, int>> itemsOnFloor = [];
  for (int i = 0; i < current.items.length; i++) {
    if (current.items[i].first == current.elevator) {
      itemsOnFloor.add(Pair(i, 0)); // Generator
    }
    if (current.items[i].second == current.elevator) {
      itemsOnFloor.add(Pair(i, 1)); // Chip
    }
  }

  // Iterate through all possible floors
  for (int nextFloor in possibleFloors) {
    // Try moving one item
    for (int i = 0; i < itemsOnFloor.length; i++) {
      final itemToMove1 = itemsOnFloor[i];
      // Create a mutable copy of the current items list
      var nextItems = List<Pair<int, int>>.from(current.items);

      // Update the position of the moved item
      int itemIndex1 = itemToMove1.first;
      int itemType1 = itemToMove1.second;
      if (itemType1 == 0) {
        // Move generator
        nextItems[itemIndex1] = Pair(nextFloor, nextItems[itemIndex1].second);
      } else {
        // Move chip
        nextItems[itemIndex1] = Pair(nextItems[itemIndex1].first, nextFloor);
      }

      // Create the potential next state
      var newState = State(nextFloor, nextItems, current.steps + 1);

      // Add to list if valid
      if (newState.isValid()) nextStates.add(newState);
    }

    // Try moving two items
    for (int i = 0; i < itemsOnFloor.length; i++) {
      for (int j = i + 1; j < itemsOnFloor.length; j++) {
        final itemToMove1 = itemsOnFloor[i];
        final itemToMove2 = itemsOnFloor[j];

        // Create a mutable copy of the current items list
        var nextItems = List<Pair<int, int>>.from(current.items);

        int itemIndex1 = itemToMove1.first;
        int itemType1 = itemToMove1.second;
        if (itemType1 == 0) {
          // Move generator
          nextItems[itemIndex1] = Pair(nextFloor, nextItems[itemIndex1].second);
        } else {
          // Move chip
          nextItems[itemIndex1] = Pair(nextItems[itemIndex1].first, nextFloor);
        }

        int itemIndex2 = itemToMove2.first;
        int itemType2 = itemToMove2.second;
        if (itemType2 == 0) {
          // Move generator
          nextItems[itemIndex2] = Pair(nextFloor, nextItems[itemIndex2].second);
        } else {
          // Move chip
          nextItems[itemIndex2] = Pair(nextItems[itemIndex2].first, nextFloor);
        }

        // Create the potential next state
        var newState = State(nextFloor, nextItems, current.steps + 1);

        // Add to list if valid
        if (newState.isValid()) nextStates.add(newState);
      }
    }
  }

  return nextStates;
}

State parseInput(List<String> input, {bool part2 = false}) {
  Map<String, int> elementIndex = {};
  List<int?> generatorFloors = [];
  List<int?> chipFloors = [];
  List<String> elementNames = []; // To keep track of order

  final genRegex = RegExp(r'(\w+) generator');
  final chipRegex = RegExp(r'(\w+)-compatible microchip');

  for (int floor = 0; floor < input.length; floor++) {
    String line = input[floor];
    int currentFloor = floor + 1; // Floors are 1-based

    // Find generators
    for (final match in genRegex.allMatches(line)) {
      String element = match.group(1)!;
      if (!elementIndex.containsKey(element)) {
        elementIndex[element] = elementIndex.length;
        elementNames.add(element);
        // Add placeholders
        generatorFloors.add(null);
        chipFloors.add(null);
      }
      generatorFloors[elementIndex[element]!] = currentFloor;
    }

    // Find chips
    for (final match in chipRegex.allMatches(line)) {
      String element = match.group(1)!;
      if (!elementIndex.containsKey(element)) {
        elementIndex[element] = elementIndex.length;
        elementNames.add(element);
        // Add placeholders
        generatorFloors.add(null);
        chipFloors.add(null);
      }
      chipFloors[elementIndex[element]!] = currentFloor;
    }
  }

  // Final items list from the parsed floors
  List<Pair<int, int>> items = [];
  for (int i = 0; i < elementNames.length; i++) {
    // Assume valid input means both generator and chip are found eventually
    items.add(Pair(generatorFloors[i]!, chipFloors[i]!));
  }

  if (part2) {
    items.add(Pair(1, 1)); // Add elerium generator and chip on floor 1
    items.add(Pair(1, 1)); // Add dilithium generator and chip on floor 1
  }

  return State(1, items, 0);
}

// Find the minimum number of steps using BFS
int findMinimumSteps(State initialState) {
  Queue<State> queue = Queue();
  Set<String> visited = {};

  queue.add(initialState);
  visited.add(initialState.getHash());

  while (queue.isNotEmpty) {
    State current = queue.removeFirst();

    if (current.isGoal()) return current.steps;

    // Explore next possible states
    for (final nextState in getNextStates(current)) {
      String hash = nextState.getHash();
      if (!visited.contains(hash)) {
        visited.add(hash);
        queue.add(nextState);
      }
    }
  }

  return -1; // If no solution found
}

void main() async {
  final lines = await File('input.txt').readAsLines();

  // Part 1
  State initialState = parseInput(lines);
  int result = findMinimumSteps(initialState);
  print('Minimum steps: $result');

  // Part 2
  State initialState2 = parseInput(lines, part2: true);
  int result2 = findMinimumSteps(initialState2);
  print('Minimum steps with additional items: $result2');
}
