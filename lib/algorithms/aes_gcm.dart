import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart'; // Import all necessary classes

// Derive a key using PBKDF2
Future<Uint8List> deriveKey(String password, Uint8List salt) async {
  final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64)); // PBKDF2 with HMAC SHA-256
  final params = Pbkdf2Parameters(salt, 100000, 32); // Parameters: salt, iteration count, key length
  pbkdf2.init(params);
  return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
}

// Encrypt using AES-GCM
Future<String> encryptGCM(String text, String password) async {
  final salt = Uint8List(16); // Fixed salt (all zeros)
  final iv = encrypt.IV(Uint8List(12)); // Fixed IV (all zeros)

  final keyBytes = await deriveKey(password, salt);
  final key = encrypt.Key(keyBytes);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));

  final encrypted = encrypter.encrypt(text, iv: iv);

  final combinedArray = Uint8List.fromList(salt + iv.bytes + encrypted.bytes);

  return base64Encode(combinedArray);
}

// Decrypt using AES-GCM
Future<String> decryptGCM(String encryptedBase64, String password) async {
  final combinedArray = base64Decode(encryptedBase64);
  final salt = Uint8List.sublistView(combinedArray, 0, 16);
  final iv = encrypt.IV(Uint8List.sublistView(combinedArray, 16, 28));
  final encryptedArray = Uint8List.sublistView(combinedArray, 28);

  final keyBytes = await deriveKey(password, salt);
  final key = encrypt.Key(keyBytes);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));

  try {
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedArray),
      iv: iv,
    );

    return utf8.decode(decrypted);
  } catch (e) {
    // Handle decryption error (e.g., wrong password)
    print("Please check text and password.");
    return "";
  }
}
