-- The state of the game
--- @class GameState
--- @field player_hp number The player's hit points
--- @field player_mana number The player's mana points
--- @field boss_hp number The boss's hit points
--- @field boss_damage number The boss's damage
--- @field shield_timer number Turns remaining for the shield effect
--- @field poison_timer number Turns remaining for the poison effect
--- @field recharge_timer number Turns remaining for the recharge effect
--- @field spent_mana number Total mana spent so far
--- @field spell_cast number[] List of spells cast so far

-- Constants for spell types
local MAGIC_MISSILE = 0
local DRAIN = 1
local SHIELD = 2
local POISON = 3
local RECHARGE = 4

--- @type number[] Costs for each spell
local spell_cost = { 53, 73, 113, 173, 229 }

-- Simulate the battle between the player and boss
--- @param boss_hp number The boss's hit points
--- @param boss_damage number The boss's damage
--- @param hard_mode boolean|nil Whether the game is in hard mode
--- @return number The minimum mana spent to win, or -1 if impossible
local function simulate_battle(boss_hp, boss_damage, hard_mode)
  hard_mode = hard_mode or false

  -- Create a priority queue implementation using a table with initial game state
  --- @type table<number, GameState>
  local pq = { {
    player_hp = 50,
    player_mana = 500,
    boss_hp = boss_hp,
    boss_damage = boss_damage,
    shield_timer = 0,
    poison_timer = 0,
    recharge_timer = 0,
    spent_mana = 0,
    spell_cast = {},
  } }

  -- Sort function for the priority queue (by spent_mana)
  local function sort_pq()
    table.sort(pq, function(a, b)
      if a.spent_mana == b.spent_mana then
        return a.boss_hp < b.boss_hp
      end
      return a.spent_mana < b.spent_mana
    end)
  end

  sort_pq()

  --- @type table<string, number>
  local visited = {}

  while #pq > 0 do
    --- @type GameState
    local current = table.remove(pq, 1)

    local state_key = string.format(
      '%d,%d,%d,%d,%d,%d',
      current.player_hp, current.player_mana, current.boss_hp,
      current.shield_timer, current.poison_timer, current.recharge_timer
    )

    if visited[state_key] and visited[state_key] <= current.spent_mana then
      goto continue
    end

    visited[state_key] = current.spent_mana

    -- Hard mode: player loses 1 HP at the start of each turn
    if hard_mode then
      current.player_hp = current.player_hp - 1
      if current.player_hp <= 0 then
        goto continue
      end
    end

    -- Apply effects at the start of player's turn
    if current.shield_timer > 0 then
      current.shield_timer = current.shield_timer - 1
    end
    if current.poison_timer > 0 then
      current.boss_hp = current.boss_hp - 3
      current.poison_timer = current.poison_timer - 1
    end
    if current.recharge_timer > 0 then
      current.player_mana = current.player_mana + 101
      current.recharge_timer = current.recharge_timer - 1
    end

    -- Check if boss is dead
    if current.boss_hp <= 0 then
      return current.spent_mana
    end

    -- Try each possible spell
    for spell = 0, 4 do
      -- Skip if not enough mana or effect still active
      if current.player_mana < spell_cost[spell + 1] then
        goto next_spell
      end
      if (spell == SHIELD and current.shield_timer > 0) or
          (spell == POISON and current.poison_timer > 0) or
          (spell == RECHARGE and current.recharge_timer > 0) then
        goto next_spell
      end

      -- Create next state
      --- @type GameState
      local next_state = {
        player_hp = current.player_hp,
        player_mana = current.player_mana - spell_cost[spell + 1],
        boss_hp = current.boss_hp,
        boss_damage = current.boss_damage,
        shield_timer = current.shield_timer,
        poison_timer = current.poison_timer,
        recharge_timer = current.recharge_timer,
        spent_mana = current.spent_mana + spell_cost[spell + 1],
        spell_cast = {}
      }

      -- Copy spell history
      for _, v in ipairs(current.spell_cast) do
        table.insert(next_state.spell_cast, v)
      end
      table.insert(next_state.spell_cast, spell)

      -- Apply spell effects
      if spell == MAGIC_MISSILE then
        next_state.boss_hp = next_state.boss_hp - 4
      elseif spell == DRAIN then
        next_state.boss_hp = next_state.boss_hp - 2
        next_state.player_hp = next_state.player_hp + 2
      elseif spell == SHIELD then
        next_state.shield_timer = 6
      elseif spell == POISON then
        next_state.poison_timer = 6
      elseif spell == RECHARGE then
        next_state.recharge_timer = 5
      end

      -- Check if boss is dead after spell
      if next_state.boss_hp <= 0 then
        return next_state.spent_mana
      end

      -- Boss turn
      -- Apply effects at the start of boss's turn
      if next_state.shield_timer > 0 then
        next_state.shield_timer = next_state.shield_timer - 1
      end
      if next_state.poison_timer > 0 then
        next_state.boss_hp = next_state.boss_hp - 3
        next_state.poison_timer = next_state.poison_timer - 1
      end
      if next_state.recharge_timer > 0 then
        next_state.player_mana = next_state.player_mana + 101
        next_state.recharge_timer = next_state.recharge_timer - 1
      end

      -- Check if boss is dead after effects
      if next_state.boss_hp <= 0 then
        return next_state.spent_mana
      end

      -- Boss attacks
      local damage = next_state.boss_damage
      if next_state.shield_timer > 0 then
        damage = damage - 7
      end
      damage = math.max(damage, 1)
      next_state.player_hp = next_state.player_hp - damage

      -- If player is still alive, add to queue
      if next_state.player_hp > 0 then
        table.insert(pq, next_state)
        sort_pq()
      end

      ::next_spell::
    end

    ::continue::
  end

  return -1
end

-- Read input file
--- @return number, number The boss's hit points and damage
local function read_input()
  --- @type string[]
  local lines = {}

  for line in io.lines('input.txt') do
    table.insert(lines, line)
  end

  local boss_hp = tonumber(string.match(lines[1], 'Hit Points: (%d+)'))
  local boss_damage = tonumber(string.match(lines[2], 'Damage: (%d+)'))
  assert(boss_hp and boss_damage, "Failed to read boss stats from input file")

  return boss_hp, boss_damage
end

local boss_hp, boss_damage = read_input()

print('Part 1: ' .. simulate_battle(boss_hp, boss_damage))
print('Part 2: ' .. simulate_battle(boss_hp, boss_damage, true))
