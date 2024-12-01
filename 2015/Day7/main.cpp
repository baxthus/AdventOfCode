#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <algorithm>

using namespace std;

unordered_map<string, uint16_t> wire_values;
unordered_map<string, vector<string>> instructions;

uint16_t get_wire_value(const string &wire)
{
    if (wire_values.find(wire) != wire_values.end())
    {
        return wire_values[wire];
    }
    if (isdigit(wire[0]))
    {
        return stoi(wire);
    }

    vector<string> &instruction = instructions[wire];
    uint16_t result;

    if (instruction.size() == 1)
    {
        result = get_wire_value(instruction[0]);
    }
    else if (instruction.size() == 2)
    {
        result = ~get_wire_value(instruction[1]);
    }
    else
    {
        uint16_t left = get_wire_value(instruction[0]);
        uint16_t right = get_wire_value(instruction[2]);
        string op = instruction[1];

        if (op == "AND")
            result = left & right;
        else if (op == "OR")
            result = left | right;
        else if (op == "LSHIFT")
            result = left << right;
        else if (op == "RSHIFT")
            result = left >> right;
    }

    wire_values[wire] = result;
    return result;
}

uint16_t solve_circuit(bool override_b = false, uint16_t b_value = 0)
{
    wire_values.clear();
    if (override_b)
    {
        wire_values["b"] = b_value;
    }
    return get_wire_value("a");
}

int main()
{
    ifstream file("input.txt");
    string line;

    while (getline(file, line))
    {
        istringstream iss(line);
        vector<string> tokens;
        string token;

        while (iss >> token)
        {
            if (token != "->")
            {
                tokens.push_back(token);
            }
        }

        string wire = tokens.back();
        tokens.pop_back();
        instructions[wire] = tokens;
    }

    uint16_t part_1 = get_wire_value("a");
    cout << "Part 1: " << part_1 << endl;
    uint16_t part_2 = solve_circuit(true, part_1);
    cout << "Part 2: " << part_2 << endl;

    return 0;
}