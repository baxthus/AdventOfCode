#include <iostream>
#include <string>

using namespace std;

bool contains_invalid_chars(const string &password)
{
    return password.find('i') != string::npos ||
           password.find('o') != string::npos ||
           password.find('l') != string::npos;
}

bool has_straight(const string &password)
{
    for (size_t i = 0; i < password.size() - 2; ++i)
    {
        if (password[i] + 1 == password[i + 1] && password[i] + 2 == password[i + 2])
        {
            return true;
        }
    }
    return false;
}

bool has_two_pairs(const string &password)
{
    int pairs = 0;
    for (size_t i = 0; i < password.size() - 1; ++i)
    {
        if (password[i] == password[i + 1])
        {
            ++pairs;
            ++i;
        }
    }
    return pairs >= 2;
}

string increment_password(string password)
{
    for (int i = password.size() - 1; i >= 0; --i)
    {
        if (password[i] == 'z')
        {
            password[i] = 'a';
        }
        else
        {
            password[i]++;
            break;
        }
    }
    return password;
}

string find_next_password(string password)
{
    do
    {
        password = increment_password(password);
    } while (contains_invalid_chars(password) || !has_straight(password) || !has_two_pairs(password));
    return password;
}

int main()
{
    string input = "hxbxwxba";
    cout << "Part 1: " << find_next_password(input) << endl;
    cout << "Part 2: " << find_next_password(find_next_password(input)) << endl;
    return 0;
}
