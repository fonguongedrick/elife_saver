import 'dart:convert';
import 'package:flutter/material.dart';
import 'patient_dashboard.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isMaleActive = true;
  DateTime? selectedDate;
  String bloodGroupValue = 'Select Blood Group';
  String factorValue = 'Select Your Factor';
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  String? userName;

  void toggleGender(bool isMale) {
    setState(() {
      isMaleActive = isMale;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String _bloodGroupDropdownValue = 'A+';
  bool _isMale = true;
  late DateTime _dobSelected;

  Future<void> _register(
      String name,
      String email,
      String phoneNumber,
      String password,
      String address,
      String bloodGroup,
      DateTime dob,
      bool isMale,
      String city,
      String factor) async {
    try {
      final response = await http.post(
        Uri.parse('https://elifesaver.online/includes/registerPatient.inc.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
          'gender': isMaleActive ? 'male' : 'female',
          'dob': selectedDate.toString(),
          'bloodGroup': bloodGroupValue,
          'factor': factorValue,
          'city': cityController.text,
          'address': addressController.text,
        },
      );
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        final userType = jsonData['type'];
        final user = jsonData['user'];
        final int userId = user['id'];
        final userName = user[userType + '_name'];
        print(userName); // Registration was successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDashboard(
              userId: userId,
              userName: userName,
              userType: userType,
            ),
          ),
        );
      } else if (jsonData['success'] == 'email exist') {
        // Email already exists
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration failed'),
              content: Text('The email you provided already exists. Please use a different email address.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Registration failed for some other reason
        String errorMessage = jsonData['message'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration failed'),
              content: Text(errorMessage),
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
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration failed'),
            content: Text('An error occurred while registering. Please try again later.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
          child: Container(
            child: SingleChildScrollView(
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
                  Card(
                    elevation: 4,
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        contentPadding: EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // Rest of the form...
                  // Rest of the form...
SizedBox(height: 16),
GestureDetector(
  onTap: () => _selectDate(context),
  child: Container(
    padding: EdgeInsets.all(8),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        selectedDate == null
            ? Text(
                'Date of Birth',
                style: TextStyle(color: Colors.grey),
              )
            : Text(
                '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: TextStyle(fontSize: 16),
              ),
        Icon(Icons.calendar_today),
      ],
    ),
  ),
),
SizedBox(height: 16),
Container(
  width: 350,
  padding: EdgeInsets.all(8),
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
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      DropdownButton<String>(
        value: bloodGroupValue,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          //color: Colors.redContinued:
        ),
        onChanged: (String? newValue) {
          setState(() {
            _bloodGroupDropdownValue = newValue!;
          });
        },
        items: <String>[
          'Select Blood Group',
          'A+',
          'A-',
          'B+',
          'B-',
          'AB+',
          'AB-',
          'O+',
          'O-'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      SizedBox(width: 8),
      DropdownButton<String>(
        value: factorValue,
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.red,
        ),
        onChanged: (String? newValue) {
          setState(() {
            factorValue = newValue!;
          });
        },
        items: <String>[
          'Select Your Factor',
          'Rh+',
          'Rh-',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    ],
  ),
),
SizedBox(height: 16),
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
    controller: cityController,
    decoration: InputDecoration(
      hintText: 'City',
      contentPadding: EdgeInsets.all(16),
      border: InputBorder.none,
    ),
  ),
),
SizedBox(height: 16),
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
    controller: addressController,
    decoration: InputDecoration(
      hintText: 'Address',
      contentPadding: EdgeInsets.all(16),
      border: InputBorder.none,
    ),
  ),
),
SizedBox(height: 32),
SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: () {
      String name = _nameController.text;
      String email = _emailController.text;
      String phoneNumber = _phoneNumberController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;
      String address = _addressController.text;
      String city = _cityController.text;
      String bloodGroup = _bloodGroupDropdownValue;
      bool isMale = _isMale;    
      DateTime dob = _dobSelected;
      String factor = factorValue;

      if (password == confirmPassword) {
        _register(name, email, phoneNumber, password, address, bloodGroup, dob, isMale, city, factor);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration failed'),
              content: Text('Passwords do not match.'),
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
    },
    child: Text(
      'Register',
      style: TextStyle(fontSize: 16),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.redAccent[400],
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
),
SizedBox(height: 20),
Center(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Already have an account?',
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(width: 5,),
      Text(
        'Login',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    ],
  ),
),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        String name = _nameController.text;
                        String email = _emailController.text;
                        String phoneNumber = _phoneNumberController.text;
                        String password = _passwordController.text;
                        String confirmPassword = _confirmPasswordController.text;
                        String address = _addressController.text;
                        String city = _cityController.text;
                        String bloodGroup = _bloodGroupDropdownValue;
                        bool isMale = _isMale;
                        DateTime dob = _dobSelected;
                        String factor = factorValue;

                        if (password == confirmPassword) {
                          _register(name, email, phoneNumber, password, address, bloodGroup, dob, isMale, city, factor);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Registration failed'),
                                content: Text('Passwords do not match.'),
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
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent[400],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
