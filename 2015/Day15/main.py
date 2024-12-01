import re
from itertools import product

def parse_input(filename):
    ingredients = {}
    with open(filename, 'r') as file:
        for line in file:
            name, properties = line.strip().split(': ')
            ingredients[name] = list(map(int, re.findall(r'-?\d+', properties)))
    return ingredients

def calculate_score(ingredients, amounts):
    totals = [0] * 5
    for ingredient, amount in zip(ingredients.values(), amounts):
        for i in range(5):
            totals[i] += ingredient[i] * amount
    
    score = 1
    for total in totals[:-1]:
        score *= max(total, 0)
    
    return score

def calculate_score2(ingredients, amounts):
    totals = [0] * 5
    for ingredient, amount in zip(ingredients.values(), amounts):
        for i in range(5):
            totals[i] += ingredient[i] * amount
    
    if totals[4] != 500:
        return 0
    
    score = 1
    for total in totals[:-1]:
        score *= max(total, 0)
    
    return score

def find_best_score(ingredients):
    best_score = 0
    for amounts in product(range(101), repeat=len(ingredients)):
        if sum(amounts) == 100:
            score = calculate_score(ingredients, amounts)
            best_score = max(best_score, score)
    return best_score

def find_best_cookie(ingredients):
    best_score = 0
    for amounts in product(range(101), repeat=len(ingredients)):
        if sum(amounts) == 100:
            score = calculate_score2(ingredients, amounts)
            best_score = max(best_score, score)
    return best_score

ingredients = parse_input('input.txt')
print(f"Part 1: {find_best_score(ingredients)}")
print(f"Part 2: {find_best_cookie(ingredients)}")