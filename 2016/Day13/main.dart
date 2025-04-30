import 'dart:collection';
import 'dart:math';

const int favoriteNumber = 1364;

// Count the number of set bits (1s) int the binary representation of a number
// Equivalent to C++'s std::bitset::count()
int countSetBits(int n) {
  int count = 0;
  // Ensure we handle non-negative numbers as the formula can produce them
  // The loop continues as long as there are bits left to check
  while (n > 0) {
    // Check if the least significant bit is 1 using bitwise AND
    count += (n & 1);
    // Right-shift the number by 1 to process the next bit
    // Using >>> for unsigned right shift, though >> works similarly for positive ints
    n >>= 1;
  }
  return count;
}

// Determines if a given coordinate (x, y) is a wall based on the puzzle's formula
bool isWall(int x, int y) {
  int formula = x * x + 3 * x + 2 * x * y + y + y * y + favoriteNumber;
  int bitCount = countSetBits(formula);
  // A location is a wall if the number of set bits is odd
  return bitCount % 2 != 0;
}

// Performs a Breadth-First Search (BFS) to find the shortest path or count reachable locations
//
// Parameters:
//  startX, startY: Starting coordinates
//  targetX, targetY: Target coordinates, used only if maxSteps is 0
//  maxSteps: Optional parameter
//    If 0 (default): Finds the shortest path to the target and returns the number of steps
//    If > 0: Finds all locations reachable within maxSteps and returns the count of unique
//            reachable locations (including the start)
//
// Returns:
//  If maxSteps is 0: The minimum number of steps to reach the target, or -1 if unreachable
//  If maxSteps > 0: The total number of unique locations visited within the step limit
int bfs(int startX, int startY, int targetX, int targetY, {int maxSteps = 0}) {
  final queue = Queue<List<int>>(); // [x, y, steps]
  final visited =
      <Point<int>>{}; // Using Point ensures value equality comparison

  final startPoint = Point(startX, startY);
  queue.add([startX, startY, 0]);
  visited.add(startPoint);

  // Main loop, continues as long as there are locations to explore
  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    final x = current[0];
    final y = current[1];
    final steps = current[2];

    // === Part 2 Logic ===
    // If maxSteps is set and we've reached the limit for this path,
    // don't explore further from this node. We still count this node
    // as visited if it was within the limit (which it is, as steps == maxSteps
    // means it was reached in maxSteps-1 and added)
    // If steps == maxSteps, we've just reached the limit, don't add neighbors
    if (maxSteps > 0 && steps == maxSteps) continue;

    // === Part 1 Logic ===
    // If we are looking for the target (maxSteps == 0) and we've found it
    if (maxSteps == 0 && x == targetX && y == targetY)
      return steps; // Return the number of steps taken

    const directions = [
      [1, 0], // Right
      [-1, 0], // Left
      [0, 1], // Down
      [0, -1], // Up
    ];

    // Explore neighbors in each direction
    for (final dir in directions) {
      final newX = x + dir[0];
      final newY = y + dir[1];
      final newPoint = Point(newX, newY);

      // Check if the neighbor is valid:
      // 1. Within bounds (non-negative coordinates)
      // 2. Not a wall
      // 3. Not already visited
      if (newX >= 0 &&
          newY >= 0 &&
          !isWall(newX, newY) &&
          !visited.contains(newPoint)) {
        // Mark the neighbor as visited
        visited.add(newPoint);
        // Enqueue the neighbor with incremented steps
        queue.add([newX, newY, steps + 1]);
      }
    }
  }

  // === Post-BFS Return Logic ===
  // If maxSteps was set (Part 2), the BFS explored all reachable locations
  // within the step limit. Return the total count of unique visited locations
  if (maxSteps != 0) return visited.length;

  // If maxSteps was 0 (Part 1) and the loop finished without finding the target
  // (meaning the queue became empty), the target is unreachable
  return -1;
}

void main() {
  const int startX = 1;
  const int startY = 1;
  const int targetX = 31;
  const int targetY = 39;

  final part1Result = bfs(startX, startY, targetX, targetY);
  print('Part 1: $part1Result');

  final part2Result = bfs(startX, startY, targetX, targetY, maxSteps: 50);
  print('Part 2: $part2Result');
}
