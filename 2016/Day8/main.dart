import 'dart:io';

class Display {
  static const int WIDTH = 50;
  static const int HEIGHT = 6;
  late List<List<bool>> screen;

  Display() {
    screen = List.generate(HEIGHT, (_) => List.filled(WIDTH, false));
  }

  void rect(int width, int height) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        screen[y][x] = true;
      }
    }
  }

  void rotateRow(int row, int amount) {
    List<bool> newRow = List.from(screen[row]);
    for (int x = 0; x < WIDTH; x++) {
      int newPos = (x + amount) % WIDTH;
      screen[row][newPos] = newRow[x];
    }
  }

  void rotateColumn(int col, int amount) {
    List<bool> oldCol = [];
    for (int y = 0; y < HEIGHT; y++) {
      oldCol.add(screen[y][col]);
    }
    for (int y = 0; y < HEIGHT; y++) {
      int newPos = (y + amount) % HEIGHT;
      screen[newPos][col] = oldCol[y];
    }
  }

  int countLitPixels() {
    int count = 0;
    for (final row in screen) {
      for (bool pixel in row) {
        if (pixel) count++;
      }
    }
    return count;
  }

  void printScreen() {
    for (final row in screen) {
      print(row.map((pixel) => pixel ? '#' : '.').join());
    }
  }
}

void main() async {
  final lines = await File('input.txt').readAsLines();
  final display = Display();

  for (String line in lines) {
    final parts = line.split(' ');

    if (parts[0] == 'rect') {
      final dimensions = parts[1].split('x');
      int width = int.parse(dimensions[0]);
      int height = int.parse(dimensions[1]);
      display.rect(width, height);
    } else if (parts[0] == 'rotate') {
      String type = parts[1];
      String pos = parts[2].substring(2);
      int amount = int.parse(parts[4]);
      int index = int.parse(pos);

      if (type == 'row') {
        display.rotateRow(index, amount);
      } else if (type == 'column') {
        display.rotateColumn(index, amount);
      }
    }
  }

  print('Number of lit pixels: ${display.countLitPixels()}');
  print('Display:');
  display.printScreen();
}
