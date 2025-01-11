import 'dart:io';

bool isValidTriangle(int a, int b, int c) {
  return (a + b > c) && (a + c > b) && (b + c > a);
}

List<String> readFile(String filename) {
  try {
    return File(filename).readAsLinesSync();
  } catch (e) {
    print('Unable to open file');
    exit(1);
  }
}

int countValidTrianglesRow(List<List<int>> triangles) {
  var validTriangles = 0;
  for (var triangle in triangles) {
    if (isValidTriangle(triangle[0], triangle[1], triangle[2])) {
      validTriangles++;
    }
  }
  return validTriangles;
}

int countValidTrianglesColumn(List<List<int>> triangles) {
  var validTriangles = 0;
  for (var i = 0; i < triangles.length; i += 3) {
    if (i + 2 < triangles.length) {
      for (var j = 0; j < 3; j++) {
        int a = triangles[i][j];
        int b = triangles[i + 1][j];
        int c = triangles[i + 2][j];
        if (isValidTriangle(a, b, c)) {
          validTriangles++;
        }
      }
    }
  }
  return validTriangles;
}

void main() {
  var lines = readFile('input.txt');

  List<List<int>> triangles = [];
  for (var line in lines) {
    var sides = line
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .map((s) => int.parse(s))
        .toList();
    triangles.add(sides);
  }

  print('Part 1: ${countValidTrianglesRow(triangles)}');
  print('Part 2: ${countValidTrianglesColumn(triangles)}');
}
