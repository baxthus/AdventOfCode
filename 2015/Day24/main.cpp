#include <fstream>
#include <functional>
#include <iostream>
#include <limits>
#include <numeric>
#include <vector>

std::vector<int> read_input(const std::string& filename) {
    std::vector<int> weights;
    std::ifstream file(filename);
    int weight;
    while (file >> weight) {
        weights.push_back(weight);
    }
    return weights;
}

long long calculate_quantum_entanglement(const std::vector<int>& group) {
    return std::accumulate(group.begin(), group.end(), 1LL, std::multiplies<long long>());
}

bool find_combination(const std::vector<int>& weights, int target_weight, int group_size, std::vector<int>& combination, int start, int current_sum) {
    if (combination.size() == group_size) {
        return current_sum == target_weight;
    }
    for (int i = start; i < weights.size(); ++i) {
        combination.push_back(weights[i]);
        if (find_combination(weights, target_weight, group_size, combination, i + 1, current_sum + weights[i])) {
            return true;
        }
        combination.pop_back();
    }
    return false;
}

long long find_ideal_quantum_entanglement(const std::vector<int>& weights, int num_groups) {
    int total_weight = std::accumulate(weights.begin(), weights.end(), 0);
    int target_weight = total_weight / num_groups;
    int n = weights.size();

    long long min_qe = std::numeric_limits<long long>::max();
    int min_group_size = n;

    for (int group_size = 1; group_size <= n / num_groups; ++group_size) {
        std::vector<int> combination;
        if (find_combination(weights, target_weight, group_size, combination, 0, 0)) {
            long long qe = calculate_quantum_entanglement(combination);
            if (qe < min_qe) {
                min_qe = qe;
            }
        }
        if (min_qe != std::numeric_limits<long long>::max()) {
            break;
        }
    }

    return min_qe;
}

int main() {
    std::vector<int> weights = read_input("input.txt");
    std::cout << "Part 1: " << find_ideal_quantum_entanglement(weights, 3) << std::endl;
    std::cout << "Part 2: " << find_ideal_quantum_entanglement(weights, 4) << std::endl;
    return 0;
}
