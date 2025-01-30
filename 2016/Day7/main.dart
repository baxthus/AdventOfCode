import 'dart:io';

bool containsAbba(String s) {
  for (int i = 0; i < s.length - 3; ++i) {
    if (s[i] != s[i + 1] && s[i] == s[i + 3] && s[i + 1] == s[i + 2]) {
      return true;
    }
  }
  return false;
}

Set<String> collectAba(String s) {
  Set<String> aba = {};
  for (int i = 0; i < s.length - 2; ++i) {
    if (s[i] != s[i + 1] && s[i] == s[i + 2]) {
      aba.add(s.substring(i, i + 3));
    }
  }
  return aba;
}

bool containsBab(String s, Set<String> abas) {
  for (int i = 0; i < s.length - 2; ++i) {
    if (s[i] != s[i + 1] && s[i] == s[i + 2]) {
      final bab = '${s[i + 1]}${s[i]}${s[i + 1]}';
      if (abas.contains(bab)) {
        return true;
      }
    }
  }
  return false;
}

void splitSegments(String ip, List<String> supernet, List<String> hypernet) {
  final re = RegExp(r'(\[|\])');
  final matches = re.allMatches(ip);
  var insideBrackets = false;
  var lastIndex = 0;

  for (var match in matches) {
    if (match.start > lastIndex) {
      final segment = ip.substring(lastIndex, match.start);
      if (insideBrackets) {
        hypernet.add(segment);
      } else {
        supernet.add(segment);
      }
    }
    insideBrackets = match.group(0) == '[';
    lastIndex = match.end;
  }

  if (lastIndex < ip.length) {
    final segment = ip.substring(lastIndex);
    if (insideBrackets) {
      hypernet.add(segment);
    } else {
      supernet.add(segment);
    }
  }
}

void main() async {
  final ips = await File('input.txt').readAsLines();

  var tlsCount = 0;
  var sslCount = 0;

  for (var ip in ips) {
    final supernet = <String>[];
    final hypernet = <String>[];
    splitSegments(ip, supernet, hypernet);

    var hasAbbaOutside = false;
    var hasAbbaInside = false;

    for (var segment in supernet) {
      if (containsAbba(segment)) {
        hasAbbaOutside = true;
        break;
      }
    }

    for (var segment in hypernet) {
      if (containsAbba(segment)) {
        hasAbbaInside = true;
        break;
      }
    }

    if (hasAbbaOutside && !hasAbbaInside) {
      tlsCount++;
    }

    final abas = <String>{};
    for (var segment in supernet) {
      abas.addAll(collectAba(segment));
    }

    var supportsSsl = false;
    for (var segment in hypernet) {
      if (containsBab(segment, abas)) {
        supportsSsl = true;
        break;
      }
    }

    if (supportsSsl) {
      sslCount++;
    }
  }

  print('Part 1: $tlsCount');
  print('Part 2: $sslCount');
}
