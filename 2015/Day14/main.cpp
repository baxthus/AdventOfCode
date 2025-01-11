#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <regex>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

class Reindeer {
public:
  std::string name;
  int speed;
  int fly_time;
  int rest_time;

  Reindeer(const std::string& name, int speed, int fly_time, int rest_time)
      : name(name), speed(speed), fly_time(fly_time), rest_time(rest_time) {}
};

int calculate_distance(int speed, int fly_time, int rest_time, int total_time) {
    int cycle_time = fly_time + rest_time;
    int full_cycles = total_time / cycle_time;
    int remaining_time = total_time % cycle_time;

    int distance = full_cycles * fly_time * speed;
    if (remaining_time > fly_time) {
        distance += fly_time * speed;
    } else {
        distance += remaining_time * speed;
    }

    return distance;
}

std::pair<std::string, int> find_winning_reindeer(const std::vector<Reindeer>& reindeer_list, int total_time) {
    int max_distance = 0;
    std::string winner;

    for (const auto& reindeer : reindeer_list) {
        int distance = calculate_distance(reindeer.speed, reindeer.fly_time, reindeer.rest_time, total_time);
        if (distance > max_distance) {
            max_distance = distance;
            winner = reindeer.name;
        }
    }

    return {winner, max_distance};
}

Reindeer parse_reindeer(const std::string& line) {
    std::regex pattern(R"((\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds\.)");
    std::smatch match;
    if (std::regex_search(line, match, pattern)) {
        std::string name = match[1];
        int speed = std::stoi(match[2]);
        int fly_time = std::stoi(match[3]);
        int rest_time = std::stoi(match[4]);
        return Reindeer(name, speed, fly_time, rest_time);
    }
    throw std::runtime_error("Invalid input");
}

std::map<std::string, int> simulate_race(const std::vector<Reindeer>& reindeer_list, int duration) {
    std::map<std::string, int> points;
    std::map<std::string, int> distances;

    for (const auto& reindeer : reindeer_list) {
        points[reindeer.name] = 0;
        distances[reindeer.name] = 0;
    }

    for (int second = 1; second <= duration; ++second) {
        for (const auto& reindeer : reindeer_list) {
            if (second % (reindeer.fly_time + reindeer.rest_time) <= reindeer.fly_time && second % (reindeer.fly_time + reindeer.rest_time) != 0) {
                distances[reindeer.name] += reindeer.speed;
            }
        }

        int max_distance = std::max_element(distances.begin(), distances.end(), [](const auto& a, const auto& b) {
            return a.second < b.second;
        })->second;

        for (const auto& reindeer : reindeer_list) {
            if (distances[reindeer.name] == max_distance) {
                points[reindeer.name]++;
            }
        }
    }

    return points;
}

int main() {
    std::ifstream file("input.txt");
    std::string line;
    std::vector<Reindeer> reindeer_list;

    while (std::getline(file, line)) {
        reindeer_list.push_back(parse_reindeer(line));
    }

    auto [winner, distance] = find_winning_reindeer(reindeer_list, 2503);
    auto points = simulate_race(reindeer_list, 2503);
    auto race_winner = std::max_element(points.begin(), points.end(), [](const auto& a, const auto& b) {
        return a.second < b.second;
    });

    std::cout << "Part 1: " << winner << " won with " << distance << " km" << std::endl;
    std::cout << "Part 2: " << race_winner->first << " won with " << race_winner->second << " points" << std::endl;

    return 0;
}
