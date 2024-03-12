import 'dart:math';

class UniqueRandomStringGenerator {
  static final _random = Random();
  static final _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  static Set<String> _generatedStrings = {};

  static String _generateRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
      length,
          (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ));
  }

  static String generateUniqueString(int length) {
    String randomString;
    do {
      randomString = _generateRandomString(length - 8);
      randomString += DateTime.now().millisecondsSinceEpoch.toString().substring(8); // Add timestamp
    } while (_generatedStrings.contains(randomString));

    _generatedStrings.add(randomString);
    return randomString;
  }
}

void main() {
  String uniqueString = UniqueRandomStringGenerator.generateUniqueString(15);
  print("Unique Random String with Timestamp: $uniqueString");
}
