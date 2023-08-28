import 'dart:convert';
import 'package:flutter/material.dart';
import 'patient_dashboard.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  bool _isLoading = false; // New variable to track loading state

  Future<void> _authenticate(String email, String password) async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });}

  void toggleGender(bool isMale) {
    setState(() {
      gender = isMale ? 'male' : 'female';
    });
  }

  Future<void> _register(
      String name, String email, String phoneNumber, String password, String confirmPassword,) async {
       setState(() {
      _isLoading = true;
      
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://elifesaver.online/includes/registerPatient.inc.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'phone': phoneNumber,
        },
      );
       setState(() {
      _isLoading = false; // Hide progress indicator
    });
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        final userType = jsonData['type'];
        final user = jsonData['user'];
        final userId = user['id'];
        final userName = user[userType + '_name'];
       SharedPreferences prefs = await SharedPreferences.getInstance();

   await prefs.setBool('LoggedIn', true);
  await prefs.setString('userType', userType);
  await prefs.setInt('userId', userId);
  await prefs.setString('userName', userName);
  await prefs.setString('phoneNumber', phoneNumber);
  await prefs.setString('password', password);
  await prefs.setString('email', email);
      
        print(userName);
        print(jsonData['error']);
        // Registration was successful
        Navigator.pushReplacement(
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
              onPressed: () {Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);},
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:20),
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
              Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 2), // changes the position of the shadow
      ),
    ],
  ),
  child: TextField(
    controller: _nameController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: 'Name',
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
),
const SizedBox(height: 30),
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 2), // changes the position of the shadow
      ),
    ],
  ),
  child: TextField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      hintText: 'Email',
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
),
const SizedBox(height: 30),
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 2), // changes the position of the shadow
      ),
    ],
  ),
  child: TextField(
    controller: _phoneNumberController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      hintText: 'Phone Number',
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  ),
),
const SizedBox(height: 30),
 Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.red,
                    ),
                  ),
                ),
                obscureText: !_passwordVisible,
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                    child: Icon(
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.red,
                    ),
                  ),
                ),
                obscureText: !_confirmPasswordVisible,
              ),
            ),
              
              const SizedBox(height: 30),
           Container(
  child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(4),
          child: TextButton(
            
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dialog dismissal on tap outside
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SpinKitCircle(
                            color: Colors.red,
                            size: 50.0,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Registering...',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              String name = _nameController.text.trim();
              String email = _emailController.text.trim();
              String phoneNumber = _phoneNumberController.text.trim();
              String password = _passwordController.text.trim();
              String confirmPassword = _confirmPasswordController.text.trim();

              if (name.isNotEmpty &&
                  email.isNotEmpty &&
                  password.isNotEmpty &&
                  confirmPassword.isNotEmpty &&
                  phoneNumber.isNotEmpty) {
                if (password == confirmPassword) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SpinKitCircle(
                                color: Colors.red,
                                size: 50.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Registering...',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  _register(name, email, phoneNumber, password, confirmPassword);
                } else {
                   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration failed'),
          content: Text('Passwords do not match. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {Navigator.pop(context);
              Navigator.pop(context);},
              child: Text('OK'),
            ),
          ],
        );
      },
    );
                }
              } else {
                showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration failed'),
          content: Text('Please fill in all the required fields.'),
          actions: [
            TextButton(
              onPressed: () {Navigator.pop(context);
              Navigator.pop(context);},
              child: Text('OK'),
            ),
          ],
        );
      },
    );
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
              
            ),
          ),
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
