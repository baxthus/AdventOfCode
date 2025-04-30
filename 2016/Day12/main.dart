import 'dart:io';

// Represents a single Assembunny instruction
class Instruction {
  final String op; // The operation code (cpy, inc, dec, jnz)
  final String x; // The first operand (register or value)
  final String? y; // The second operand (register or jump offset)

  Instruction(this.op, this.x, [this.y]);

  @override
  String toString() {
    return '$op $x ${y ?? ""}'; // For debugging
  }
}

// Reads instructions from the specified file
// Each line is parsed into an Instruction object
Future<List<Instruction>> readInstructions(String filename) async {
  final instructions = <Instruction>[];
  final lines = await File(filename).readAsLines();

  for (final line in lines) {
    if (line.trim().isEmpty) continue; // Skip empty lines

    final parts = line.split(' ');
    final op = parts[0];
    final x = parts[1];
    // The y operand is optional (e.g. for inc, dec)
    final y = parts.length > 2 ? parts[2] : null;

    instructions.add(Instruction(op, x, y));
  }

  return instructions;
}

// Gets the integer value of an operand
// If the operand is a register name (a, b, c, d), it returns the register's value
// Otherwise, it parses the operand as an integer
int getValue(String operand, Map<String, int> registers) {
  final immediateValue = int.tryParse(operand);
  if (immediateValue != null)
    return immediateValue;
  else {
    // If not an integer, assume it's a register name
    return registers[operand]!;
  }
}

// Executes the Assembunny program
// Modifies the registers map based on the instructions
void executeProgram(
  List<Instruction> instructions,
  Map<String, int> registers,
) {
  int pc = 0; // Program counter: index of the next instruction

  while (pc >= 0 && pc < instructions.length) {
    final instr = instructions[pc]; // Current instruction

    switch (instr.op) {
      case 'cpy':
        // Copy value of x (register or immediate) to register y
        final value = getValue(instr.x, registers);
        // instr.y cannot be null for cpy
        registers[instr.y!] = value;
        pc++;
        break;

      case 'inc':
        // Increment the value in register x
        registers[instr.x] = registers[instr.x]! + 1;
        pc++;
        break;

      case 'dec':
        // Decrement the value in register x
        registers[instr.x] = registers[instr.x]! - 1;
        pc++;
        break;

      case 'jnz':
        // Jump to a new instruction if x is not zero
        final value = getValue(instr.x, registers);
        if (value != 0) {
          // Get the jump offset (y operand) and parse it
          // instr.y cannot be null for jnz
          final jumpOffset = int.parse(instr.y!);
          pc += jumpOffset; // Apply the jump
        } else {
          // If x is zero, just move to the next instruction
          pc++;
        }
        break;

      default:
        throw Exception('Unknown instruction: ${instr.op}');
    }
  }
}

void main() async {
  final instructions = await readInstructions('input.txt');

  final registers1 = {'a': 0, 'b': 0, 'c': 0, 'd': 0};
  executeProgram(instructions, registers1);
  print('Part 1 - Value in register a: ${registers1["a"]}');

  final registers2 = {'a': 0, 'b': 0, 'c': 1, 'd': 0}; // Only c differs
  executeProgram(instructions, registers2);
  print('Part 2 - Value in register a: ${registers2["a"]}');
}
