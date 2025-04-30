const favoriteNumber = 1364;

// Count the number of set bits (1s) in the binary representation of a number
// Equivalent to C++'s std::bitset::count()
function countSetBits(n: number): number {
  let count = 0;
  // Ensure we handle non-negative numbers as the formula can produce them
  // The loop continues as log as there are bits left to check
  while (n > 0) {
    // Check if the least significant bit is 1 using bitwise AND
    count += n & 1;
    // Right-shift the number by 1 to process the next bit
    // Using >>> for unsigned right shift ensures correct behavior for large numbers
    // although >> works similarly for positive integers within the 32-bit signed range
    n >>>= 1;
  }
  return count;
}

// Determines if a given coordinate (x, y) is a wall based on the puzzle's formula
function isWall(x: number, y: number): boolean {
  const formula = x * x + 3 * x + 2 * x * y + y + y * y + favoriteNumber;
  const bitCount = countSetBits(formula);
  // A location is a wall if the number of set bits is odd
  return bitCount % 2 !== 0;
}

type Point = { x: number; y: number };
type QueueState = Point & { steps: number };

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
//  If maxSteps is 0: The minimum number of steps to react the target, or -1 if unreachable
//  If maxSteps > 0: The total number of unique locations visited within the step limit
function bfs(
  startX: number,
  startY: number,
  targetX: number,
  targetY: number,
  maxSteps: number = 0,
): number {
  // Using array.shift() is inefficient for large arrays, but I don't want to use a external library
  const queue: QueueState[] = [];
  // Use a Set of strings 'x,y' to track visited locations efficiently
  // Using Point objects directly in a Set doesn't work well due to reference equality
  const visited = new Set<string>();

  const startKey = `${startX},${startY}`;
  queue.push({ x: startX, y: startY, steps: 0 });
  visited.add(startKey);

  while (queue.length > 0) {
    const current = queue.shift()!;
    const { x, y, steps } = current;

    // === Part 2 Logic ===
    // If maxSteps is set and we've reached the limit for this path,
    // don't explore further from this node. We still count this node
    // as visited if it was within the limit (which it is, as steps = maxSteps
    // means itr was reached in maxSteps-1 and added)
    // If steps == maxSteps, we've just reached the limit, don't add neighbors
    if (maxSteps > 0 && steps === maxSteps) continue;

    // === Part 1 Logic ===
    // If we are looking for the target (maxSteps == 0) and we've found it
    if (maxSteps === 0 && x === targetX && y === targetY) return steps; // Return the number of steps taken

    const directions: [number, number][] = [
      [1, 0], // Right
      [-1, 0], // Left
      [0, 1], // Down
      [0, -1], // Up
    ];

    // Explore neighbors in each direction
    for (const [dx, dy] of directions) {
      const newX = x + dx;
      const newY = y + dy;
      const newKey = `${newX},${newY}`;

      // Check if the neighbor is valid:
      // 1. Within bounds (non-negative coordinates)
      // 2. Not a wall
      // 3. Not already visited
      if (
        newX >= 0 &&
        newY >= 0 &&
        !isWall(newX, newY) &&
        !visited.has(newKey)
      ) {
        // Mark the neighbor as visited
        visited.add(newKey);
        // Enqueue the neighbor with the incremented steps
        queue.push({ x: newX, y: newY, steps: steps + 1 });
      }
    }
  }

  // === Post-BFS Logic ===
  // If maxSteps was set (Part 2), the BFS explored all reachable locations
  // within the step limit. Return the total count of unique visited locations
  if (maxSteps > 0) return visited.size;

  // If maxSteps was 0 (Part 1) and the loop finished without finding the target
  // (meaning the queue became empty), the target is unreachable
  return -1;
}

const startX = 1;
const startY = 1;
const targetX = 31;
const targetY = 39;

const part1Result = bfs(startX, startY, targetX, targetY);
console.log(`Part 1: ${part1Result}`);

const part2Result = bfs(startX, startY, targetX, targetY, 50);
console.log(`Part 2: ${part2Result}`);
