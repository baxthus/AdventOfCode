from collections import defaultdict, deque
from dataclasses import dataclass
import sys
from typing import Deque, Dict, Tuple

@dataclass
class Bot:
    low: int = -1
    high: int = -1
    low_target: int = -1
    high_target: int = -1
    low_is_output: bool = False
    high_is_output: bool = False

bots: Dict[int, Bot] = defaultdict(Bot)
outputs: Dict[int, int] = {}
initial_chips: Deque[Tuple[int, int]] = deque()

def give_chip(bot_id: int, value: int):
    bot = bots[bot_id]
    if bot.low == -1:
        bot.low = value
    else:
        bot.high = value
        if bot.low > bot.high:
            bot.low, bot.high = bot.high, bot.low

def process_bot(bot_id: int):
    bot = bots[bot_id]

    if bot.low == -1 or bot.high == -1:
        return

    if bot.low == 17 and bot.high == 61:
        print(f'Bot {bot_id} is responsible for comparing value-17 microchips and value-61 microchips.')

    if bot.low_is_output:
        outputs[bot.low_target] = bot.low
    else:
        give_chip(bot.low_target, bot.low)
        process_bot(bot.low_target)

    if bot.high_is_output:
        outputs[bot.high_target] = bot.high
    else:
        give_chip(bot.high_target, bot.high)
        process_bot(bot.high_target)

    bot.low = -1
    bot.high = -1

if __name__ == '__main__':
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        parts = line.split()

        if parts[0] == 'value':
            value = int(parts[1])
            bot_id = int(parts[5])
            initial_chips.append((bot_id, value))
        elif parts[0] == 'bot':
            bot_id = int(parts[1])

            low_target_type = parts[5]
            low_target_id = int(parts[6])

            high_target_type = parts[10]
            high_target_id = int(parts[11])

            bot = bots[bot_id]
            bot.low_target = low_target_id
            bot.low_is_output = (low_target_type == 'output')

            bot.high_target = high_target_id
            bot.high_is_output = (high_target_type == 'output')

    while initial_chips:
        bot_id, value = initial_chips.popleft()
        give_chip(bot_id, value)
        process_bot(bot_id)

    product = outputs.get(0, 0) * outputs.get(1, 0) * outputs.get(2, 0)
    print(f'The product of the values in outputs 0, 1, and 2 is: {product}')
