#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

void calculate_matchsticks(const string &line, int &total_code, int &total_memory)
{
    total_code += line.length();

    string unquoted = line.substr(1, line.length() - 2);

    stringstream ss;
    for (size_t i = 0; i < unquoted.length(); ++i)
    {
        if (unquoted[i] == '\\')
        {
            if (unquoted[i + 1] == 'x')
            {
                i += 3;
                total_memory++;
            }
            else
            {
                i++;
                total_memory++;
            }
        }
        else
        {
            ss << unquoted[i];
            total_memory++;
        }
    }
}

void calculate_matchsticks_2(const string &line, int &total_code, int &total_encoded)
{
    total_code += line.length();

    string encoded = "\"";
    for (char c : line)
    {
        if (c == '\\')
        {
            encoded += "\\\\";
        }
        else if (c == '\"')
        {
            encoded += "\\\"";
        }
        else
        {
            encoded += c;
        }
    }
    encoded += "\"";

    total_encoded += encoded.length();
}

int main()
{
    ifstream input_file("input.txt");

    string line;
    int total_code = 0, total_memory = 0;
    int total_code_2 = 0, total_encoded = 0;

    while (getline(input_file, line))
    {
        calculate_matchsticks(line, total_code, total_memory);
        calculate_matchsticks_2(line, total_code_2, total_encoded);
    }

    cout << "Total code: " << total_code << endl;
    cout << "Total memory: " << total_memory << endl;
    cout << "Difference: " << total_code - total_memory << endl;

    cout << "Total code 2: " << total_code_2 << endl;
    cout << "Total encoded: " << total_encoded << endl;
    cout << "Difference 2: " << total_encoded - total_code_2 << endl;

    return 0;
}