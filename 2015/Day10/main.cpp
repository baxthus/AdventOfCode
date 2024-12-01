#include <iostream>
#include <fstream>
#include <string>

using namespace std;

string look_and_say(const string &input)
{
    string result;
    int count = 1;

    for (size_t i = 1; i <= input.length(); ++i)
    {
        if (i < input.length() && input[i] == input[i - 1])
        {
            count++;
        }
        else
        {
            result += to_string(count) + input[i - 1];
            count = 1;
        }
    }

    return result;
}

int main()
{
    string input = "3113322113";

    for (int i = 0; i < 40; ++i)
    {
        input = look_and_say(input);
    }

    cout << "Part 1: " << input.length() << endl;

    for (int i = 0; i < 10; ++i)
    {
        input = look_and_say(input);
    }

    cout << "Part 2: " << input.length() << endl;

    return 0;
}