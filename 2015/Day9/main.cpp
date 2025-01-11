#include <algorithm>
#include <cstddef>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <limits>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

typedef std::map<std::pair<std::string, std::string>, int> Distances;
typedef std::set<std::string> Cities;

std::pair<Distances, Cities> parse_input(const std::string& filename)  {
    Distances distances;
    Cities cities;
    std::ifstream file(filename);
    std::string line;

    while (getline(file, line)) {
        std::stringstream ss(line);
        std::string route, distance_str;
        getline(ss, route, '=');
        getline(ss, distance_str);
        route = route.substr(0, route.size() - 1); // Remove trailing space
        int distance = std::stoi(distance_str);

        size_t pos = route.find(" to ");
        std::string city1 = route.substr(0, pos);
        std::string city2 = route.substr(pos + 4);

        distances[{city1, city2}] = distance;
        distances[{city2, city1}] = distance;
        cities.insert(city1);
        cities.insert(city2);
    }

    return {distances, cities};
}

int calculate_route_distance(const std::vector<std::string>& route, const Distances& distances) {
    int totalDistance = 0;
    for (size_t i = 0; i < route.size() - 1; i++) {
        totalDistance += distances.at({route[i], route[i + 1]});
    }
    return totalDistance;
}

int find_shortest_route(const Distances& distances, const Cities& cities) {
    std::vector<std::string> city_list(cities.begin(), cities.end());
    int shortest_distance = std::numeric_limits<int>::max();

    do {
        int distance = calculate_route_distance(city_list, distances);
        shortest_distance = std::min(shortest_distance, distance);
    } while (std::next_permutation(city_list.begin(), city_list.end()));

    return shortest_distance;
}

int find_longest_route(const Distances& distances, const Cities& cities) {
    std::vector<std::string> city_list(cities.begin(), cities.end());
    int longest_distance = 0;

    do {
        int distance = calculate_route_distance(city_list, distances);
        longest_distance = std::max(longest_distance, distance);
    } while (std::next_permutation(city_list.begin(), city_list.end()));

    return longest_distance;
}

int main() {
    auto [distances, cities] = parse_input("input.txt");

    std::cout << "Part 1: " << find_shortest_route(distances, cities) << std::endl;
    std::cout << "Part 2: " << find_longest_route(distances, cities) << std::endl;

    return 0;
}
