local bots = {}
local outputs = {}

---@param bot_id number
---@return table
local function get_bot(bot_id)
    if not bots[bot_id] then
        bots[bot_id] = {
            low = -1,
            high = -1,
            low_target = -1,
            high_target = -1,
            low_is_output = false,
            high_is_output = false,
        }
    end
    return bots[bot_id]
end

---@param bot_id number
---@param value number
---@return nil
local function give_chip(bot_id, value)
    local bot = get_bot(bot_id)
    if (bot.low == -1) then
        bot.low = value
    else
        bot.high = value
        if bot.low > bot.high then
            bot.low, bot.high = bot.high, bot.low
        end
    end
    bots[bot_id] = bot
end

---@param bot_id number
---@return nil
local function process_bot(bot_id)
    local bot = bots[bot_id]
    if bot.low ~= -1 and bot.high ~= -1 then
        if bot.low == 17 and bot.high == 61 then
            print('Bot ' .. bot_id .. ' is responsible for comparing value-17 microchips and value-61 microchips')
        end

        if bot.low_is_output then
            outputs[bot.low_target] = bot.low
        else
            give_chip(bot.low_target, bot.low)
            process_bot(bot.low_target)
        end

        if bot.high_is_output then
            outputs[bot.high_target] = bot.high
        else
            give_chip(bot.high_target, bot.high)
            process_bot(bot.high_target)
        end

        bot.low = -1
        bot.high = -1
    end
    bots[bot_id] = bot
end

local initial_chips = {}

for line in io.lines('input.txt') do
    local words = {}
    for word in line:gmatch('%S+') do
        table.insert(words, word)
    end

    if words[1] == 'value' then
        local value = tonumber(words[2])
        local bot_id = tonumber(words[6])
        table.insert(initial_chips, { bot_id, value })
    elseif words[1] == 'bot' then
        local bot_id = tonumber(words[2])
        local low_type = words[6]
        local low_target = tonumber(words[7])
        local high_type = words[11]
        local high_target = tonumber(words[12])

        assert(bot_id, 'bot_id is nil')

        local bot = get_bot(bot_id)
        bot.low_target = low_target
        bot.high_target = high_target
        bot.low_is_output = (low_type == 'output')
        bot.high_is_output = (high_type == 'output')
        bots[bot_id] = bot
    end
end

for _, instruction in ipairs(initial_chips) do
    local bot_id, value = instruction[1], instruction[2]
    give_chip(bot_id, value)
    process_bot(bot_id)
end

print('The product of the values in outputs 0, 1, and 2 is: ' .. (outputs[0] * outputs[1] * outputs[2]))
