import 'dart:convert';
import 'package:flutter/material.dart';
import 'patient_dashboard.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientRegisterPage extends StatefulWidget {
  @override
  _PatientRegisterPageState createState() => _PatientRegisterPageState();
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? gender;
  int? userId;

  void toggleGender(bool isMale) {
    setState(() {
      gender = isMale ? 'male' : 'female';
    });
  }

  Future<void> _register(
      String name, String email, String phoneNumber, String password, String confirmPassword, String gender) async {
    try {
      final response = await http.post(
        Uri.parse('https://elifesaver.online/includes/registerPatient.inc.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'gender': gender,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'phone': phoneNumber,
        },
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        final userType = jsonData['type'];
        final user = jsonData['user'];
        userId = user['id'];
        final userName = user[userType + '_name'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('registered', true);
        prefs.setInt('userId', userId!);
        prefs.setString('userName', userName);

        print(userName);
        // Registration was successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDashboard(userId: userId!, userName: userName, userType: userType),
          ),
        );
      } else if (jsonData['error'] == 'Email already exists') {
        // Email already exists
        _showDialog('Registration failed', 'The email you provided already exists. Please use a different email address.');
      } else {
        // Registration failed for some other reason
        String errorMessage = jsonData['error'];
        _showDialog('Registration failed', errorMessage);
      }
    } catch (error) {
      print(error);
      _showDialog('Registration failed', 'An error occurred while registering. Please try again later.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/e_life_saver.png',
                  height: 150.0,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CardInput(
                controller: _nameController,
                hintText: 'Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              CardInput(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CardInput(
                controller: _phoneNumberController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CardInput(
                controller: _passwordController,
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CardInput(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_confirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => toggleGender(true),
                    style: ElevatedButton.styleFrom(
                      primary: gender == 'male' ? Colors.red : Colors.white,
                      onPrimary: gender == 'male' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: const Text('Male'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => toggleGender(false),
                    style: ElevatedButton.styleFrom(
                      primary: gender == 'female' ? Colors.red : Colors.white,
                      onPrimary: gender == 'female' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: const Text('Female'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    String phoneNumber = _phoneNumberController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirmPassword = _confirmPasswordController.text.trim();
                    String genderValue = gender ?? 'N/A';

                    if (name.isNotEmpty &&
                        email.isNotEmpty &&
                        password.isNotEmpty &&
                        confirmPassword.isNotEmpty &&
                        phoneNumber.isNotEmpty) {
                      if (password == confirmPassword) {
                        _register(name, email, phoneNumber, password, confirmPassword, genderValue);
                      } else {
                        _showDialog('Registration failed', 'Passwords do not match. Please try again.');
                      }
                    } else {
                      _showDialog('Registration failed', 'Please fill in all the required fields.');
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardInput extends StatelessWidget {
  const CardInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
