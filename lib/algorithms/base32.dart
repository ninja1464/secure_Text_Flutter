const String base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

String base32Encode(String input) {
  String output = "";
  int buffer = 0;
  int bitsLeft = 0;

  for (int i = 0; i < input.length; i++) {
    buffer = (buffer << 8) | input.codeUnitAt(i);
    bitsLeft += 8;

    while (bitsLeft >= 5) {
      int index = (buffer >> (bitsLeft - 5)) & 31;
      output += base32Chars[index];
      bitsLeft -= 5;
    }
  }

  if (bitsLeft > 0) {
    int index = (buffer << (5 - bitsLeft)) & 31;
    output += base32Chars[index];
  }

  return output;
}

String base32Decode(String input) {
  const String base32Lookup = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  String output = "";
  int buffer = 0;
  int bitsLeft = 0;

  input = input.toUpperCase().replaceAll(RegExp(r'=+$'), '');

  try {
    for (int i = 0; i < input.length; i++) {
      int index = base32Lookup.indexOf(input[i]);
      if (index == -1) {
        throw ArgumentError("Invalid Base32 character");
      }

      buffer = (buffer << 5) | index;
      bitsLeft += 5;

      if (bitsLeft >= 8) {
        output += String.fromCharCode((buffer >> (bitsLeft - 8)) & 255);
        bitsLeft -= 8;
      }
    }
  } catch (e) {
    // Handle decryption error
    print("Either the selected algorithm or the encrypted string is wrong.");
    return "";
  }

  return output;
}

// void main() {
//   String originalText = "Hello, World!";
//   String encoded = base32Encode(originalText);
//   print("Encoded: $encoded"); // Encoded string
//
//   String decoded = base32Decode(encoded);
//   print("Decoded: $decoded"); // Decoded string should match original text
// }
