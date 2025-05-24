#include <iostream>
#include <string>

char get_prev_tile(const std::string &prev_row, int index) {
  if (index < 0 || index >= prev_row.length())
    return '.';
  return prev_row[index];
}

int main() {
  std::string current_row;
  if (!(std::cin >> current_row)) {
    std::cerr << "Error reading input" << std::endl;
    return 1;
  }

  int total_rows = 40;
  int total_rows2 = 400000;
  int width = current_row.length();
  long long safe_tile_count = 0;
  long long total_safe_count = 0;

  if (width == 0) {
    std::cerr << "No tiles in the current row" << std::endl;
    return 1;
  }

  for (int i = 0; i < total_rows2; i++) {
    for (char tile : current_row)
      if (tile == '.')
        total_safe_count++;

    if (i == total_rows - 1)
      safe_tile_count = total_safe_count;

    if (i < total_rows2 - 1) {
      std::string next_row = "";
      next_row.reserve(width);

      for (int j = 0; j < width; j++) {
        char left = get_prev_tile(current_row, j - 1);
        char right = get_prev_tile(current_row, j + 1);

        next_row += (left != right) ? '^' : '.';
      }

      current_row = std::move(next_row);
    }
  }

  std::cout << "Total safe tiles in " << total_rows
            << " rows: " << safe_tile_count << std::endl;
  std::cout << "Total safe tiles in " << total_rows2
            << " rows: " << total_safe_count << std::endl;
  return 0;
}
