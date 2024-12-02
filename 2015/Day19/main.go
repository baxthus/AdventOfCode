// Had to pull up Go for this one, wtf???
package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strings"
)

type Replacement struct {
	from, to string
}

func main() {
	replacements, molecule := parseInput("input.txt")

	distinctMolecules := mutate(molecule, replacements)
	fmt.Printf("Part 1: %d\n", len(distinctMolecules))

	steps := search(molecule, replacements)
	fmt.Printf("Part 2: %d\n", steps)
}

func parseInput(filename string) ([]Replacement, string) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	var replacements []Replacement
	var molecule string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		if strings.Contains(line, "=>") {
			parts := strings.Split(line, " => ")
			replacements = append(replacements, Replacement{parts[0], parts[1]})
		} else if line != "" {
			molecule = line
		}
	}

	return replacements, molecule
}

func mutate(molecule string, replacements []Replacement) map[string]bool {
	distinctMolecules := make(map[string]bool)
	for _, rep := range replacements {
		for i := 0; i < len(molecule); i++ {
			if strings.HasPrefix(molecule[i:], rep.from) {
				newMolecule := molecule[:i] + rep.to + molecule[i+len(rep.from):]
				distinctMolecules[newMolecule] = true
			}
		}
	}
	return distinctMolecules
}

func search(molecule string, replacements []Replacement) int {
	target := molecule
	mutations := 0

	for target != "e" {
		tmp := target
		for _, rep := range replacements {
			index := strings.Index(target, rep.to)
			if index >= 0 {
				target = target[:index] + rep.from + target[index+len(rep.to):]
				mutations++
				break
			}
		}

		if tmp == target {
			target = molecule
			mutations = 0
			shuffleReplacements(replacements)
		}
	}

	return mutations
}

func shuffleReplacements(replacements []Replacement) {
	rand.Shuffle(len(replacements), func(i, j int) {
		replacements[i], replacements[j] = replacements[j], replacements[i]
	})
}
