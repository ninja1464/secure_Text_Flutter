import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secure_text_flutter/algorithms/aes_cbc.dart';
import 'package:secure_text_flutter/algorithms/aes_gcm.dart';
import 'package:secure_text_flutter/algorithms/base32.dart';
import 'package:secure_text_flutter/algorithms/base64.dart';

void main() {
  runApp(const SecureTextApp());
}

class SecureTextApp extends StatelessWidget {
  const SecureTextApp({super.key});

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
  String _encryptionMethodLabel = "Select Encryption Method";
  String _stringDataLabel = "Text String";
  String _passwordDataLabel = "Encryption Password";
  String _resultDataLabel = "Encrypted Data";
  Color _encryptBtnColor = const Color(0xFF007bff);
  Color _decryptBtnColor = const Color(0xFF4ebb78);
  String _actionBtn = "Encrypt";
  String _textInputData = "";
  String _passwordInputData = "";
  String _resultInputData = "Process Might Take Few Seconds";
  String encryptionMethod = 'AES-GCM';
  bool _isTextFieldEnabled = true;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  void encryptText() {
    setState(() {
      _resultInputData =  "Process Might Take Few Seconds";
      _stringDataLabel = "Text String";
      _passwordDataLabel = "Encryption Password";
      _resultDataLabel = "Encrypted Data";
      _encryptionMethodLabel = "Select Encryption Method";
      _encryptBtnColor = const Color(0xFF007bff);
      _decryptBtnColor = const Color(0xFF4ebb78);
      _actionBtn = "Encrypt";
      _controller1.text = '';
      _controller2.text = '';
    });
    print("Encryption Method selected");
  }

  void decryptText() {
    setState(() {
      _resultInputData =  "Process Might Take Few Seconds, It Will Not Work If Data Provided Is Wrong.";
      _stringDataLabel = "Encrypted String";
      _passwordDataLabel = "Decryption Password";
      _resultDataLabel = "Decrypted Data";
      _encryptionMethodLabel = "Select Decryption Method";
      _encryptBtnColor = const Color(0xFF4ebb78);
      _decryptBtnColor = const Color(0xFF007bff);
      _actionBtn = "Decrypt";
      _controller1.text = '';
      _controller2.text = '';
    });
    print('Decryption Method selected');
  }

  void _collectInput() {
    setState(() {
      _textInputData = _controller1.text;
    });
  }

  void _collectPassword() {
    setState(() {
      _passwordInputData = _controller2.text;
    });
  }

  void _toggleTextFieldState(bool state) {
    setState(() {
      _isTextFieldEnabled = state; // Toggle the boolean state
    });
  }

  void _validateInput() async {
    setState(() async {
      if(encryptionMethod == 'BASE32' || encryptionMethod == 'BASE64') {
        if (_textInputData.isEmpty) {
          _showAlertDialog();
        } else {
          await getOutput();
        }
      } else {
        if (_textInputData.isEmpty || _passwordInputData.isEmpty) {
          _showAlertDialog();
        } else {
          await getOutput();
        }
      }
    });
  }

  Future<void> getOutput() async {
    setState(() async {
      // await Future.delayed(Duration(seconds: 20));
      print('=>>getOutput function got  called');
      _collectInput();
      _collectPassword();

      String outputData = '';

      if (_actionBtn == 'Encrypt') {
        switch (encryptionMethod) {
          case 'AES-GCM':
            outputData = await encryptGCM(_textInputData, _passwordInputData);
            break;
          case 'AES-CBC':
            outputData = await encryptCBC(_textInputData, _passwordInputData);
            break;
          case 'BASE64':
            outputData = encodeToBase64(_textInputData);
            break;
          case 'BASE32':
            outputData = base32Encode(_textInputData);
            break;
        }
      } else if (_actionBtn == 'Decrypt') {
        switch (encryptionMethod) {
          case 'AES-GCM':
            outputData = await decryptGCM(_textInputData, _passwordInputData);
            break;
          case 'AES-CBC':
            outputData = await decryptCBC(_textInputData, _passwordInputData);
            break;
          case 'BASE64':
            outputData = decodeFromBase64(_textInputData);
            break;
          case 'BASE32':
            outputData = base32Decode(_textInputData);
            break;
        }
      }
      setState(() {
        if (outputData == ""){
          _showAlertDialog();
        }
        _resultInputData = outputData;
      });
    });
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.black,
          title: const Text(
            'Secure Text',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Please enter both text and password to encrypt/decrypt.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Secure Text',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color(0xFF007bff),
      ),
      body: Container(
        color: const Color(0xFF4ebb78),
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
                            side: const BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                        child: const Text(
                          'Select Encrypt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: decryptText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _decryptBtnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                        child: const Text(
                          'Select Decrypt',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _encryptionMethodLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 16),
                Text(
                  _stringDataLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _controller1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter text to encrypt/decrypt',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                    _textInputData = value;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  _passwordDataLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  obscureText: true,
                  enabled: _isTextFieldEnabled,
                  onChanged: (value) {
                    _passwordInputData = value;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _validateInput,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007bff),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                    child: Text(_actionBtn),
                  )
                ),
                const SizedBox(height: 16),
                Text(
                  _resultDataLabel,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8), // Padding inside the container
                  width: double.infinity, // Container will take the full width available
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Black border color
                    borderRadius: BorderRadius.circular(4), // Rounded corners
                    color: Colors.white, // Black background color
                  ),
                  height: 90, // Fixed height of the container
                  child: SingleChildScrollView(
                    child: Text(
                      _resultInputData,
                      style: const TextStyle(color: Colors.black), // White text color for better visibility on black background
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _resultInputData));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFe0e0e0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 2.0),
                    ),
                    minimumSize: const Size(50, 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  child: const Text('Copy'),
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
          _toggleTextFieldState(value != 'BASE64' && value != 'BASE32');
        });
      },
    );
  }
}
