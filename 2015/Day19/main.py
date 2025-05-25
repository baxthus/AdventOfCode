from typing import List, NamedTuple, Set, Tuple
import sys
import random


class Replacement(NamedTuple):
    frm: str # 'from' is a reserved keyword
    to: str

def parse_input() -> Tuple[List[Replacement], str]:
    replacements: List[Replacement] = []
    molecule = ''
    lines = sys.stdin.readlines()

    for line in lines:
        line = line.strip()
        if '=>' in line:
            parts = line.split(' => ')
            replacements.append(Replacement(frm=parts[0], to=parts[1]))
        elif line:
            molecule = line

    return replacements, molecule

def mutate(molecule: str, replacements: List[Replacement]) -> Set[str]:
    distinct_molecules: Set[str] = set()
    for rep in replacements:
        pos = 0
        while True:
            pos = molecule.find(rep.frm, pos)
            if pos == -1: break
            new_molecule = molecule[:pos] + rep.to + molecule[pos + len(rep.frm):]
            distinct_molecules.add(new_molecule)
            pos += len(rep.frm)
    return distinct_molecules

def search(molecule: str, replacements: List[Replacement]) -> int:
    target = molecule
    mutations = 0

    # For the search, it's more efficient to work backwards from the molecule to 'e'
    # The replacements should be (longer_string, shorter_string)
    # and we try to replace occurrencess of longer_string with shorter_string

    # Create a mutable copy for shuffling
    current_replacements = list(replacements)

    while target != 'e':
        tmp_target = target
        applied_replacement_in_iteration = False
        for rep in current_replacements:
            # Try to find rep.to (the longer string) in the target
            # and replace it with rep.frm (the shorter string, often an element)
            index = target.find(rep.to)
            if index != -1:
                target = target[:index] + rep.frm + target[index + len(rep.to):]
                mutations += 1
                applied_replacement_in_iteration = True
                break

        if not applied_replacement_in_iteration:
            # This means we might be stuck or reached a point where current order of replacements doesn't help
            # Reset and shuffle
            target = molecule
            mutations = 0
            random.shuffle(current_replacements)

    return mutations

def main():
    replacements, molecule = parse_input()

    distinct_molecules = mutate(molecule, replacements)
    print(f"Part 1: {len(distinct_molecules)}")

    num_steps = search(molecule, replacements)
    print(f"Part 2: {num_steps}")

if __name__ == "__main__":
    main()
