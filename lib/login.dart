import 'dart:convert';
import 'package:flutter/material.dart';
import 'donor_info.dart';
import 'package:http/http.dart' as http;
import 'patient_dashboard.dart';
import 'dashboard.dart';
import 'doctor_dashboard.dart';
import 'patient_registeration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoginPage extends StatefulWidget {
late String userName;
 late int userId;
 late String userType;
  @override
  
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // New variable to track loading state
  bool _showLoadingDialog = false;
   Future<void> _authenticate(String email, String password) async {
  setState(() {
    _isLoading = true;
    _showLoadingDialog = true;
  });

  final response = await http.post(
    Uri.parse('https://elifesaver.online/includes/login.inc.php'),
    body: {
      'email': email,
      'password': password,
    },
  );

  

  final jsonData = jsonDecode(response.body);
  if (jsonData['success'] == true) {
    setState(() {
    _isLoading = false;
    _showLoadingDialog = false; // Hide progress indicator
  });
    final userType = jsonData['type'];
    final user = jsonData['user'];
    final userName = user[userType + '_name'];
    final int userId = user['id'];
    final btsNumber = user['bts_number'];
    final phoneNumber = user['phone'];
    final city = user['city'];
    final address = user['address'];
    final userEmail = user['email'];
    final userPassword = user['password'];
    final bloodGroup = user['blood_group'];
    final gender = user['gender'];
    print(user);
    print(userType);

    // After the user successfully logs in
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('LoggedIn', true);
    await prefs.setString('userType', userType);
    await prefs.setInt('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('phoneNumber', phoneNumber.toString());
    await prefs.setString('address', address.toString());
    await prefs.setString('city', city.toString());
    await prefs.setString('password', userPassword.toString());
    await prefs.setString('btsNumber', btsNumber.toString());
    await prefs.setString('email', userEmail.toString());
    await prefs.setString('bloodGroup', bloodGroup.toString());
    await prefs.setString('gender', gender.toString());

    // Authentication was successful
    if (userType == 'patient') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientDashboard(
            userId: userId,
            userName: userName,
            userType: userType,
          ),
        ),
      );
    } else if (userType == 'donor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            userId: userId,
            userName: userName,
            userType: userType,
            phoneNumber: phoneNumber.toString(),
            address: address.toString(),
            city: city.toString(),
            password: userPassword.toString(),
            btsNumber: btsNumber.toString(),
            email: userEmail.toString(),
            bloodGroup: bloodGroup.toString(),
            gender: gender.toString(),
          ),
        ),
      );
    }
  } else if (jsonData['success'] == false) {
    if (jsonData['error'] == 'Wrong Password') {
      // Authentication failed due to wrong password
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login failed'),
            content: Text('Invalid email or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Authentication failed due to missing fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login failed'),
            content: Text('Fill all the fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

   }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 75,),
                Center(
                child: GestureDetector(
                   onTap: () {
                          
                        },
                  child: Image.asset(
                    'assets/e_life_saver.png',
                    height: 120.0,
                   
                  ),
                ),
              ),
                Row(
                  children: [
                    
              SizedBox(height: 8,),
                    Text(
                      'Login',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text(
                      'Welcome back, login to continue',
                      textAlign: TextAlign.left,
                    ),
                  ]
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 4),
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
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.only(left: 4),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                 border: InputBorder.none,
                                  hintText: 'Password',
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 150),
                      child: GestureDetector(
                        onTap: () {
                               /* Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DoctorScanPage()),
                                );*/
                              },
                        child: Text(
                          'Forgot your password?',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
            child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
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
                              'Logging in...',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                ); */
                _authenticate(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
                  ),
          ),
            SizedBox(
                      height: 140,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                        ),
                        SizedBox(width: 0.1,),
                
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => PatientRegisterPage()),
                                );
                              },
                              child: Text(
                                'Request for blood',
                                style: TextStyle(color:Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                  // After successful login, navigate to the DonorDashboard and pass the userId and userType
                  Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                  builder: (context) => DonorInfoPage(),
            ),
                  );
                
                              },
                              child: Text(
                                'Become a donor',
                                style: TextStyle(color:Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

