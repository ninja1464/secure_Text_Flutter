import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


String _EncryptionMethodLabel = "Select Encryption Method";
String _StringDataLabel = "Text String";
String _PasswordDataLabel = "Encryption Password";
String _ResultDataLabel = "Encrypted Data";
Color _encryptBtnColor = Color(0xFF007bff);
Color _decryptBtnColor = Color(0xFF4ebb78);
String _actionBtn = "Encrypt";
String _textInputData = "";
String _passwordInputData = "";
String _resultInputData = "";

void main() {
  runApp(SecureTextApp());
}

class SecureTextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secure Text',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SecureTextScreen(),
    );
  }
}

class SecureTextScreen extends StatefulWidget {
  @override
  _SecureTextScreenState createState() => _SecureTextScreenState();
}

class _SecureTextScreenState extends State<SecureTextScreen> {
  String encryptionMethod = 'AES-GCM';
  String inputText = '';
  String password = '';
  String resultText = '';

  void encryptText() {
    setState(() {
      setState(() {
        _StringDataLabel = "Text String";
        _PasswordDataLabel = "Encryption Password";
        _ResultDataLabel = "Encrypted Data";
        _EncryptionMethodLabel = "Select Encryption Method";
        _encryptBtnColor = Color(0xFF007bff);
        _decryptBtnColor = Color(0xFF4ebb78);
        _actionBtn = "Encrypt";
      });
      print("Encryption Method selected");
      // base64();
    });
  }

  void decryptText() {
    setState(() {
      setState(() {
        _StringDataLabel = "Encrypted String";
        _PasswordDataLabel = "Decryption Password";
        _ResultDataLabel = "Decrypted Data";
        _EncryptionMethodLabel = "Select Decryption Method";
        _encryptBtnColor = Color(0xFF4ebb78);
        _decryptBtnColor = Color(0xFF007bff);
        _actionBtn = "Decrypt";
      });
      print('Decryption Method selected'); // Print "Hello Bunty" when the Decrypt button is clicked
    });
  }

  void getOutput() {
    setState(() {
      resultText = 'Decrypted with $encryptionMethod: $inputText';
      print('Performed Encryyption');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Secure Text',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFF007bff),
      ),
      body: Container(
        color: Color(0xFF4ebb78),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: encryptText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _encryptBtnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                        child: Text(
                          'Encrypt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: decryptText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _decryptBtnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                        child: Text(
                          'Decrypt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  _EncryptionMethodLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildRadioListTile('AES-GCM'),
                    buildRadioListTile('AES-CBC'),
                    buildRadioListTile('BASE64'),
                    buildRadioListTile('BASE32'),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  _StringDataLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter String',
                    border: OutlineInputBorder(),
                    hintText: 'Enter text to encrypt/decrypt',
                  ),
                  onChanged: (value) {
                    inputText = value;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  _PasswordDataLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 16),

                // Add a button in the center
                Center(
                  child: ElevatedButton(
                    onPressed: getOutput, // Define the action that should be taken when the button is pressed
                    child: Text(_actionBtn),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007bff), // Background color
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 2.0),// Border radius
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 16),
                Text(
                  _ResultDataLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 90,
                  child: SingleChildScrollView(
                    child: Text(resultText),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: resultText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFe0e0e0), // Background color
                    foregroundColor: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 2.0),// Border radius
                    ),
                    minimumSize: Size(50, 10), // Set the minimum width and height
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Internal padding
                  ),
                  child: Text('Copy'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  RadioListTile<String> buildRadioListTile(String method) {
    return RadioListTile<String>(
      title: Text(method),
      value: method,
      groupValue: encryptionMethod,
      onChanged: (value) {
        setState(() {
          encryptionMethod = value!;
        });
      },
    );
  }
}
