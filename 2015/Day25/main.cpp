#include <cstdio>
#include <fstream>
#include <iostream>
#include <string>
const long long initial_code = 20151125;
const long long multiplier = 252533;
const long long divider = 33554393;

long long get_code_at_position(int row, int col) {
    int diagonal = row + col - 1;
    long long sequence_number = (diagonal * (diagonal - 1)) / 2 + col;

    long long code = initial_code;
    for (long long i = 1; i < sequence_number; ++i) {
        code = (code * multiplier) % divider;
    }

    return code;
}

long long part1(std::string line) {
    int row, col;
    sscanf(line.c_str(), "To continue, please consult the code grid in the manual.  Enter the code at row %d, column %d.", &row, &col);

    long long code = get_code_at_position(row, col);
    return code;
}

int main() {
    std::ifstream input_file("input.txt");

    std::string line;
    std::getline(input_file, line);
    input_file.close();

    std::cout << "Part 1: " << part1(line) << std::endl;

    return 0;
}
