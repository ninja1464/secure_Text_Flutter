import 'dart:convert';

// Function to encode a string to Base64
String encodeToBase64(String str) {
  // Convert the string to UTF-8 bytes
  List<int> utf8Bytes = utf8.encode(str);

  // Encode the UTF-8 bytes to Base64
  String base64Str = base64Encode(utf8Bytes);

  return base64Str;
}

// Function to decode a Base64 encoded string
String decodeFromBase64(String encodedStr) {
  try {
    // Decode the Base64 string to UTF-8 bytes
    List<int> decodedBytes = base64Decode(encodedStr);

    // Convert the UTF-8 bytes back to a string
    String decodedStr = utf8.decode(decodedBytes);

    return decodedStr;
  } catch (e) {
    // Handle decoding error
    print("Either the selected algorithm or the encrypted string is wrong.");
    return "";
  }
}

// void main() {
//   String originalText = "Hello, World!";
//   String encoded = encodeToBase64(originalText);
//   print("Encoded: $encoded"); // Encoded string
//
//   String decoded = decodeFromBase64(encoded);
//   print("Decoded: $decoded"); // Decoded string should match original text
// }
