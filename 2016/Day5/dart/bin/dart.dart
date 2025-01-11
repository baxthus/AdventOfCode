import 'dart:convert';

import 'package:crypto/crypto.dart';

String findPassword(String doorId) {
  var password = "";
  var index = 0;

  while (password.length < 8) {
    var toHash = doorId + index.toString();
    var bytes = utf8.encode(toHash);
    var hash = md5.convert(bytes);

    if (hash.toString().startsWith("00000")) {
      password += hash.toString()[5];
    }

    index++;
  }

  return password;
}

String findPassword2(String doorId) {
  var password = List.filled(8, '_');
  var index = 0;
  var filledPositions = 0;

  while (filledPositions < 8) {
    var toHash = doorId + index.toString();
    var bytes = utf8.encode(toHash);
    var hash = md5.convert(bytes);

    if (hash.toString().startsWith("00000")) {
      var positionChar = hash.toString()[5];
      if (int.tryParse(positionChar) != null) {
        var position = int.parse(positionChar);
        if (position < 8 && password[position] == '_') {
          password[position] = hash.toString()[6];
          filledPositions++;
        }
      }
    }

    index++;
  }

  return password.join();
}

void main() {
  const doorId = "ojvtpuvg";

  print("Part 1: ${findPassword(doorId)}");
  print("Part 2: ${findPassword2(doorId)}");
}
