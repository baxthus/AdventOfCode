bool containsInvalidCharacters(String password) {
  return password.contains('i') ||
      password.contains('o') ||
      password.contains('l');
}

bool hasStraight(String password) {
  for (var i = 0; i < password.length - 2; ++i) {
    if (password.codeUnitAt(i) + 1 == password.codeUnitAt(i + 1) &&
        password.codeUnitAt(i) + 2 == password.codeUnitAt(i + 2)) return true;
  }
  return false;
}

bool hasTwoPairs(String password) {
  var pairs = 0;
  for (var i = 0; i < password.length - 1; ++i) {
    if (password[i] == password[i + 1]) {
      pairs++;
      i++;
    }
  }
  return pairs >= 2;
}

String incrementPassword(String password) {
  var codeUnits = List<int>.from(password.codeUnits);
  for (var i = codeUnits.length - 1; i >= 0; --i) {
    if (codeUnits[i] == 'z'.codeUnitAt(0)) {
      codeUnits[i] = 'a'.codeUnitAt(0);
    } else {
      codeUnits[i]++;
      break;
    }
  }
  return String.fromCharCodes(codeUnits);
}

String findNextPassword(String password) {
  do {
    password = incrementPassword(password);
  } while (containsInvalidCharacters(password) ||
      !hasStraight(password) ||
      !hasTwoPairs(password));
  return password;
}

void main() {
  const input = 'hxbxwxba';
  var password = findNextPassword(input);
  print('Part 1: $password');
  print('Part 2: ${findNextPassword(password)}');
}
