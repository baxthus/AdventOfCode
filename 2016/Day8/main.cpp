#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

class Display {
private:
  static const int WIDTH = 50;
  static const int HEIGHT = 6;
  std::vector<std::vector<bool>> screen;

public:
  Display() : screen(HEIGHT, std::vector<bool>(WIDTH, false)) {}

  void rect(int width, int height) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        screen[y][x] = true;
      }
    }
  }

  void rotate_row(int row, int amount) {
    std::vector<bool> newRow = screen[row];
    for (int x = 0; x < WIDTH; x++) {
      int newPos = (x + amount) % WIDTH;
      screen[row][newPos] = newRow[x];
    }
  }

  void rotate_column(int col, int amount) {
    std::vector<bool> oldCol;
    for (int y = 0; y < HEIGHT; y++) {
      oldCol.push_back(screen[y][col]);
    }
    for (int y = 0; y < HEIGHT; y++) {
      int newPos = (y + amount) % HEIGHT;
      screen[newPos][col] = oldCol[y];
    }
  }

  int count_lit_pixels() const {
    int count = 0;
    for (const auto &row : screen) {
      for (bool pixel : row) {
        if (pixel)
          count++;
      }
    }
    return count;
  }

  void print_screen() const {
    for (const auto &row : screen) {
      for (bool pixel : row) {
        std::cout << (pixel ? '#' : '.');
      }
      std::cout << std::endl;
    }
  }
};

int main() {
  std::ifstream file("input.txt");
  std::string line;
  Display display;

  while (std::getline(file, line)) {
    std::istringstream iss(line);
    std::string command;
    iss >> command;

    if (command == "rect") {
      std::string dimensions;
      iss >> dimensions;
      int width = std::stoi(dimensions.substr(0, dimensions.find('x')));
      int height = std::stoi(dimensions.substr(dimensions.find('x') + 1));
      display.rect(width, height);
    } else if (command == "rotate") {
      std::string type, pos;
      int index, amount;
      iss >> type >> pos;
      pos = pos.substr(2); // Remove =x or y=
      iss >> command >> amount;
      index = std::stoi(pos);

      if (type == "row")
        display.rotate_row(index, amount);
      else if (type == "column")
        display.rotate_column(index, amount);
    }
  }

  std::cout << "Number of lit pixels: " << display.count_lit_pixels()
            << std::endl;
  std::cout << "Final screen:" << std::endl;
  display.print_screen();

  return 0;
}