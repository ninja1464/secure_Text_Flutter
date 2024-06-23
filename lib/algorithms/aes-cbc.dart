import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt; // Alias the encrypt package
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:flutter/foundation.dart';

// Function to derive a key using PBKDF2 and AES-CBC
Future<pc.KeyParameter> deriveKeyAES(String password, Uint8List salt) async {
  final keyDerivator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64))
    ..init(pc.Pbkdf2Parameters(salt, 100000, 32));
  final key = keyDerivator.process(utf8.encode(password) as Uint8List);
  return pc.KeyParameter(key);
}

// Function to encrypt text using AES-CBC
Future<String> encryptCBC(String text, String password) async {
  final salt = Uint8List(16); // All-zero salt
  final iv = encrypt.IV(Uint8List(16)); // All-zero IV
  final keyParam = await deriveKeyAES(password, salt);
  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(keyParam.key), mode: encrypt.AESMode.cbc, padding: null)); // Disable padding to match JS if needed

  // Pad text to block size (16 bytes) manually
  final paddedText = padToBlockSize(text);

  final encrypted = encrypter.encrypt(paddedText, iv: iv);

  // Combine salt, IV, and encrypted data
  final combined = Uint8List(salt.length + iv.bytes.length + encrypted.bytes.length)
    ..setAll(0, salt)
    ..setAll(salt.length, iv.bytes)
    ..setAll(salt.length + iv.bytes.length, encrypted.bytes);

  return base64Encode(combined);
}

// Function to pad text to block size (16 bytes)
String padToBlockSize(String text) {
  final blockSize = 16;
  final paddingRequired = blockSize - (text.length % blockSize);
  return text + String.fromCharCode(paddingRequired) * paddingRequired;
}

// Function to decrypt text using AES-CBC
Future<String> decryptCBC(String encryptedBase64, String password) async {
  try {
    final combined = base64Decode(encryptedBase64);
    final salt = combined.sublist(0, 16);
    final iv = encrypt.IV(combined.sublist(16, 32));
    final encryptedBytes = combined.sublist(32);
    final keyParam = await deriveKeyAES(password, salt);

    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(keyParam.key), mode: encrypt.AESMode.cbc, padding: null)); // Disable padding to match JS if needed

    final decrypted = encrypter.decrypt(encrypt.Encrypted(encryptedBytes), iv: iv);

    // Remove padding
    return unpadFromBlockSize(decrypted);
  } catch (e) {
    // Handle decryption error (e.g., wrong password)
    debugPrint('Decryption failed: $e');
    return '';
  }
}

// Function to remove padding from the decrypted text
String unpadFromBlockSize(String text) {
  final paddingValue = text.codeUnitAt(text.length - 1);
  return text.substring(0, text.length - paddingValue);
}