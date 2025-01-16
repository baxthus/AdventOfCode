local Item = {}
Item._index = Item

function Item:new(name, cost, damage, armor)
    local item = {
        name = name,
        cost = cost,
        damage = damage,
        armor = armor
    }
    setmetatable(item, Item)
    return item
end

local armors = {
    Item:new('No Armor', 0, 0, 0),
    Item:new('Leather', 13, 0, 1),
    Item:new('Chainmail', 31, 0, 2),
    Item:new('Splintmail', 53, 0, 3),
    Item:new('Bandedmail', 75, 0, 4),
    Item:new('Platemail', 102, 0, 5)
}

local rings = {
    Item:new('No Ring', 0, 0, 0),
    Item:new('Damage +1', 25, 1, 0),
    Item:new('Damage +2', 50, 2, 0),
    Item:new('Damage +3', 100, 3, 0),
    Item:new('Defense +1', 20, 0, 1),
    Item:new('Defense +2', 40, 0, 2),
    Item:new('Defense +3', 80, 0, 3)
}

local weapons = {
    Item:new('Dagger', 8, 4, 0),
    Item:new('Shortsword', 10, 5, 0),
    Item:new('Warhammer', 25, 6, 0),
    Item:new('Longsword', 40, 7, 0),
    Item:new('Greataxe', 74, 8, 0)
}

local function read_lines(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    return lines
end

local function split(str, sep)
    local result = {}
    for match in (str .. sep):gmatch('(.-)' .. sep) do
        table.insert(result, match)
    end
    return result
end

local function min(a, b)
    if a < b then return a else return b end
end

local function max(a, b)
    if a > b then return a else return b end
end

local function simulate_battle(player_hp, player_damage, player_armor, boss_hp, boss_damage, boss_armor)
    while true do
        boss_hp = boss_hp - max(1, player_damage - boss_armor)
        if boss_hp <= 0 then return true end
        player_hp = player_hp - max(1, boss_damage - player_armor)
        if player_hp <= 0 then return false end
    end
end

local function find_least_gold_to_win(boss_hp, boss_damage, boss_armor)
    local min_gold = 1000000
    for _, weapon in ipairs(weapons) do
        for _, armor in ipairs(armors) do
            for i = 1, #rings do
                for j = i, #rings do
                    local ring1 = rings[i]
                    local ring2 = rings[j]
                    local gold = weapon.cost + armor.cost + ring1.cost + ring2.cost
                    local damage = weapon.damage + armor.damage + ring1.damage + ring2.damage
                    local defense = weapon.armor + armor.armor + ring1.armor + ring2.armor

                    if simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor) then
                        min_gold = min(min_gold, gold)
                    end
                end
            end
        end
    end
    return min_gold
end

local function find_most_gold_to_lose(boss_hp, boss_damage, boss_armor)
    local max_gold = 0
    for _, weapon in ipairs(weapons) do
        for _, armor in ipairs(armors) do
            for i = 1, #rings do
                for j = i, #rings do
                    local ring1 = rings[i]
                    local ring2 = rings[j]

                    if i == j and ring1.name ~= 'No Ring' then goto continue end

                    local gold = weapon.cost + armor.cost + ring1.cost + ring2.cost
                    local damage = weapon.damage + armor.damage + ring1.damage + ring2.damage
                    local defense = weapon.armor + armor.armor + ring1.armor + ring2.armor

                    if not simulate_battle(100, damage, defense, boss_hp, boss_damage, boss_armor) then
                        max_gold = max(max_gold, gold)
                    end
                    ::continue::
                end
            end
        end
    end
    return max_gold
end

local lines = read_lines('input.txt')
local boss_hp = tonumber(split(lines[1], ': ')[2])
local boss_damage = tonumber(split(lines[2], ': ')[2])
local boss_armor = tonumber(split(lines[3], ': ')[2])

print('Part 1: ' .. find_least_gold_to_win(boss_hp, boss_damage, boss_armor))
print('Part 2: ' .. find_most_gold_to_lose(boss_hp, boss_damage, boss_armor))
