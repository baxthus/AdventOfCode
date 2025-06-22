import 'dart:io';

class Range {
  int start;
  int end;

  Range(this.start, this.end);
}

int part1(List<Range> ranges) {
  int lowestAllowedIp = 0;

  for (final Range range in ranges) {
    if (lowestAllowedIp < range.start) break;

    if (lowestAllowedIp <= range.end) lowestAllowedIp = range.end + 1;
  }

  return lowestAllowedIp;
}

int part2(List<Range> ranges) {
  if (ranges.isEmpty) return 0;

  int totalBlockedCount = 0;
  int mergedStart = ranges[0].start;
  int mergedEnd = ranges[0].end;

  for (int i = 1; i < ranges.length; i++) {
    if (ranges[i].start <= mergedEnd + 1) {
      if (ranges[i].end > mergedEnd) mergedEnd = ranges[i].end;
    } else {
      totalBlockedCount += (mergedEnd - mergedStart + 1);
      mergedStart = ranges[i].start;
      mergedEnd = ranges[i].end;
    }
  }
  totalBlockedCount += (mergedEnd - mergedStart + 1);

  const int totalIps = 4294967296; // 2^32
  return totalIps - totalBlockedCount;
}

void main() {
  final List<Range> ranges = [];

  String? line;
  while ((line = stdin.readLineSync()) != null && line!.isNotEmpty) {
    final List<String> parts = line.split('-');
    ranges.add(Range(int.parse(parts[0]), int.parse(parts[1])));
  }

  ranges.sort((a, b) => a.start.compareTo(b.start));

  print('Part 1: ${part1(ranges)}');
  print('Part 2: ${part2(ranges)}');
}
