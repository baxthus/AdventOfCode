import 'dart:io';
import 'dart:math';

typedef Distances = Map<String, int>;
typedef Cities = Set<String>;

(Distances, Cities) parseInput(String filename) {
  Distances distances = {};
  Cities cities = {};
  var lines = File(filename).readAsLinesSync();

  for (var line in lines) {
    var parts = line.split(' = ');
    if (parts.length == 2) {
      var route = parts[0];
      var distance = int.parse(parts[1]);
      var citiesPair = route.split(' to ');
      var city1 = citiesPair[0];
      var city2 = citiesPair[1];
      distances['$city1-$city2'] = distance;
      distances['$city2-$city1'] = distance;
      cities.add(city1);
      cities.add(city2);
    }
  }

  return (distances, cities);
}

int calculateRouteDistance(List<String> route, Distances distances) {
  var totalDistance = 0;
  for (var i = 0; i < route.length - 1; i++) {
    totalDistance += distances['${route[i]}-${route[i + 1]}']!;
  }
  return totalDistance;
}

int findShortestRoute(
    Distances distances, Cities cities, List<List<String>> permutations) {
  var shortestDistance = double.infinity;

  for (var route in permutations) {
    var distance = calculateRouteDistance(route, distances);
    shortestDistance = min(shortestDistance, distance.toDouble());
  }

  return shortestDistance.toInt();
}

int findLongestRoute(
    Distances distances, Cities cities, List<List<String>> permutations) {
  var longestDistance = double.negativeInfinity;

  for (var route in permutations) {
    var distance = calculateRouteDistance(route, distances);
    longestDistance = max(longestDistance, distance.toDouble());
  }

  return longestDistance.toInt();
}

List<List<T>> permute<T>(List<T> items) {
  if (items.length == 1) {
    return [items];
  }

  var perms = <List<T>>[];
  for (var i = 0; i < items.length; i++) {
    var current = items[i];
    var remaining = List<T>.from(items)..removeAt(i);
    for (var perm in permute(remaining)) {
      perms.add([current, ...perm]);
    }
  }

  return perms;
}

void main() {
  var (distances, cities) = parseInput('input.txt');
  var permutations = permute(cities.toList());

  print('Part 1: ${findShortestRoute(distances, cities, permutations)}');
  print('Part 2: ${findLongestRoute(distances, cities, permutations)}');
}
