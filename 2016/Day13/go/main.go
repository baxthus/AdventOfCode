package main

import (
	"fmt"
	"math/bits"
)

const favoriteNumber = 1364

func isWall(x, y int) bool {
	if x < 0 || y < 0 {
		return true
	}
	formula := x*x + 3*x + 2*x*y + y + y*y + favoriteNumber
	bitCount := bits.OnesCount(uint(formula))
	return bitCount%2 != 0
}

type Point struct {
	x, y int
}

type State struct {
	pt    Point
	steps int
}

func bfs(startX, startY, targetX, targetY, maxSteps int) int {
	queue := []State{}
	visited := make(map[Point]struct{})

	startPoint := Point{startX, startY}
	if isWall(startX, startY) {
		return -1
	}

	queue = append(queue, State{pt: startPoint, steps: 0})
	visited[startPoint] = struct{}{}

	directions := []Point{
		{1, 0},
		{-1, 0},
		{0, 1},
		{0, -1},
	}

	head := 0
	for head < len(queue) {
		current := queue[head]
		head++

		if maxSteps != 0 && current.steps >= maxSteps {
			continue
		}

		if maxSteps == 0 && current.pt.x == targetX && current.pt.y == targetY {
			return current.steps
		}

		for _, dir := range directions {
			nextX := current.pt.x + dir.x
			nextY := current.pt.y + dir.y
			nextPoint := Point{nextX, nextY}

			if nextX >= 0 && nextY >= 0 && !isWall(nextX, nextY) {
				if _, found := visited[nextPoint]; !found {
					visited[nextPoint] = struct{}{}
					queue = append(queue, State{pt: nextPoint, steps: current.steps + 1})
				}
			}
		}
	}

	if maxSteps != 0 {
		return len(visited)
	}

	return -1
}

func main() {
	startX, startY := 1, 1
	targetX, targetY := 31, 39

	fmt.Println("Part 1:", bfs(startX, startY, targetX, targetY, 0))
	fmt.Println("Part 2:", bfs(startX, startY, targetX, targetY, 50))
}
