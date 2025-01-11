import 'dart:io';

void main() async {
  final data = await File('input.txt').readAsLines();

  final reindeerList = data.map(parseReindeer).toList();
  final winnerEntry = findWinningReindeer(reindeerList, 2503);

  final points = simulateRace(reindeerList, 2503);
  final raceWinner = points.entries.reduce((a, b) => a.value > b.value ? a : b);

  print('Part 1: ${winnerEntry!.key} won with ${winnerEntry.value} km');
  print('Part 2: ${raceWinner.key} won with ${raceWinner.value} points');
}

int calculateDistance(int speed, int flyTime, int restTime, int totalTime) {
  final cycleTime = flyTime + restTime;
  final fullCycles = totalTime ~/ cycleTime;
  final remainingTime = totalTime % cycleTime;

  var distance = fullCycles * flyTime * speed;
  if (remainingTime > flyTime)
    distance += flyTime * speed;
  else
    distance += remainingTime * speed;

  return distance;
}

MapEntry<String, int>? findWinningReindeer(
    List<Reindeer?> reindeerList, int totalTime) {
  if (reindeerList.any((reindeer) => reindeer == null)) return null;
  var maxDistance = 0;
  late String winner;

  for (var reindeer in reindeerList) {
    final distance = calculateDistance(
        reindeer!.speed, reindeer.flyTime, reindeer.restTime, totalTime);
    if (distance > maxDistance) {
      maxDistance = distance;
      winner = reindeer.name;
    }
  }

  return MapEntry(winner, maxDistance);
}

Reindeer? parseReindeer(String line) {
  final pattern = RegExp(
      r'(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.');
  final match = pattern.firstMatch(line);
  if (match != null) {
    final name = match.group(1);
    final speed = int.parse(match.group(2)!);
    final flyTime = int.parse(match.group(3)!);
    final restTime = int.parse(match.group(4)!);
    return Reindeer(name!, speed, flyTime, restTime);
  }
  return null;
}

Map<String, int> simulateRace(List<Reindeer?> reindeerList, int duration) {
  if (reindeerList.any((reindeer) => reindeer == null)) return {};

  final points = {for (var reindeer in reindeerList) reindeer!.name: 0};
  final distances = {for (var reindeer in reindeerList) reindeer!.name: 0};

  for (var second = 1; second <= duration; second++) {
    for (var reindeer in reindeerList) {
      if (second % (reindeer!.flyTime + reindeer.restTime) <=
              reindeer.flyTime &&
          second % (reindeer.flyTime + reindeer.restTime) != 0)
        distances[reindeer.name] = distances[reindeer.name]! + reindeer.speed;
    }

    final maxDistance = distances.values.reduce((a, b) => a > b ? a : b);
    for (var reindeer in reindeerList) {
      if (distances[reindeer!.name] == maxDistance)
        points[reindeer.name] = points[reindeer.name]! + 1;
    }
  }

  return points;
}

class Reindeer {
  String name;
  int speed;
  int flyTime;
  int restTime;

  Reindeer(this.name, this.speed, this.flyTime, this.restTime);
}
