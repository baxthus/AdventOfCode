#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <unordered_set>
#include <vector>

bool contains_abba(const std::string& s) {
    for (size_t i = 0; i < s.size() - 3; ++i) {
        if (s[i] != s[i + 1] && s[i] == s[i + 3] && s[i + 1] == s[i + 2]) {
            return true;
        }
    }
    return false;
}

std::unordered_set<std::string> collect_aba(const std::string& s) {
    std::unordered_set<std::string> aba;
    for (size_t i = 0; i < s.size() - 2; ++i) {
        if (s[i] != s[i + 1] && s[i] == s[i + 2]) {
            aba.insert(s.substr(i, 3));
        }
    }
    return aba;
}

bool contains_bab(const std::string& s, const std::unordered_set<std::string>& abas) {
    for (size_t i = 0; i < s.size() - 2; ++i) {
        if (s[i] != s[i + 1] && s[i] == s[i + 2]) {
            std::string bab = {s[i + 1], s[i], s[i + 1]};
            if (abas.find(bab) != abas.end()) {
                return true;
            }
        }
    }
    return false;
}

void split_segments(const std::string& ip, std::vector<std::string>& supernet, std::vector<std::string>& hypernet) {
    std::regex re(R"((\[|\]))");
    std::regex_token_iterator it(ip.begin(), ip.end(), re, {-1, 0});
    bool inside_brackets = false;
    for (; it != std::sregex_token_iterator(); ++it) {
        if (it->str() == "[") {
            inside_brackets = true;
        } else if (it->str() == "]") {
            inside_brackets = false;
        } else {
            if (inside_brackets) {
                hypernet.push_back(it->str());
            } else {
                supernet.push_back(it->str());
            }
        }
    }
}

int main() {
    std::ifstream input_file("input.txt");
    std::vector<std::string> ips;
    std::string line;

    while (std::getline(input_file, line)) {
        ips.push_back(line);
    }

    int tls_count = 0;
    int ssl_count = 0;

    for (const auto& ip : ips) {
        std::vector<std::string> supernet;
        std::vector<std::string> hypernet;
        split_segments(ip, supernet, hypernet);

        bool has_abba_outside = false;
        bool has_abba_inside = false;

        for (const auto& segment : supernet) {
            if (contains_abba(segment)) {
                has_abba_outside = true;
                break;
            }
        }

        for (const auto& segment : hypernet) {
            if (contains_abba(segment)) {
                has_abba_inside = true;
                break;
            }
        }

        if (has_abba_outside && !has_abba_inside) {
            tls_count++;
        }

        std::unordered_set<std::string> abas;
        for (const auto& segment : supernet) {
            auto segment_abas = collect_aba(segment);
            abas.insert(segment_abas.begin(), segment_abas.end());
        }

        bool supports_ssl = false;
        for (const auto& segment : hypernet) {
            if (contains_bab(segment, abas)) {
                supports_ssl = true;
                break;
            }
        }

        if (supports_ssl) {
            ssl_count++;
        }
    }

    std::cout << "Part 1: " << tls_count << std::endl;
    std::cout << "Part 2: " << ssl_count << std::endl;

    return 0;
}
