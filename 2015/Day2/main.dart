import 'dart:io';

int calculateWrappingPaper(String dimensions) {
  var parts = dimensions.split('x').map(int.parse).toList();
  int l = parts[0], w = parts[1], h = parts[2];

  int surfaceArea = 2 * l * w + 2 * w * h + 2 * h * l;
  int smallestSide = [l * w, w * h, h * l].reduce((a, b) => a < b ? a : b);
  return surfaceArea + smallestSide;
}

int totalWrappingPaper(List<String> lines) {
  int total = 0;
  for (var line in lines) {
    total += calculateWrappingPaper(line);
  }
  return total;
}

int calculateRibbon(String dimensions) {
  var parts = dimensions.split('x').map(int.parse).toList();
  int l = parts[0], w = parts[1], h = parts[2];

  int volume = l * w * h;
  int smallestPerimeter = [2 * l + 2 * w, 2 * w + 2 * h, 2 * h + 2 * l]
      .reduce((a, b) => a < b ? a : b);
  return volume + smallestPerimeter;
}

int totalRibbon(List<String> lines) {
  int total = 0;
  for (var line in lines) {
    total += calculateRibbon(line);
  }
  return total;
}

void main() async {
  var lines = await new File('input.txt').readAsLines();
  print('Part 1: ${totalWrappingPaper(lines)}');
  print('Part 2: ${totalRibbon(lines)}');
}
