import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';

class DonorAppealPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userType;
  final String phoneNumber; 
  final String address;
  final String city;
  final String password;
  final String btsNumber;
  final String email;
  final String bloodGroup;

  DonorAppealPage({
    required this.userId,
    required this.userName,
    required this.userType,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.password,
    required this.btsNumber,
    required this.email,
    required this.bloodGroup
  });


  @override

  _DonorAppealPageState createState() => _DonorAppealPageState();
}

class _DonorAppealPageState extends State<DonorAppealPage> {
  void _onLoginSuccess(BuildContext context, String userName, int userId, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(userId: widget.userId,
      userName: widget.userName,
      userType: widget.userType,
      phoneNumber: widget.phoneNumber,
      email: widget.email,
      city: widget.city,
      address: widget.address,
      password: widget.password,
      btsNumber: widget.btsNumber,
      bloodGroup:widget.bloodGroup),
      ),
    );
  }
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String selectedBloodGroup = 'A+';
  final List<String> rhFactors = ['Positive', 'Negative'];
  String selectedRhFactor = 'Positive';
  int numberOfBags = 2;
  int? patientId = null ;
  
  int max(int a, int b) {
    return a > b ? a : b;
  }
  final hospitalLocationController = TextEditingController();
  final medicalInformationController = TextEditingController();
  

  @override
  void dispose() {
    hospitalLocationController.dispose();
    medicalInformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Make New Appeal',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/blood_appeal.png',
                height: 180.0,
                width: 180,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    height: 40,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Number of Bags',
                    ),
                  ),
                  SizedBox(width: 8,),
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              numberOfBags = max(numberOfBags - 1, 1);
                            });
                          },
                          child: Text(
                            '-',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          numberOfBags.toString(),
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(width: 16.0),
                        InkWell(
                          onTap: () {
                            setState(() {
                              numberOfBags = numberOfBags + 1;
                            });
                          },
                          child: Text(
                            '+',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Select Blood Group',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: selectedBloodGroup,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBloodGroup = newValue!;
                          });
                        },
                        items: bloodGroups.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Select Rh Factor',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: selectedRhFactor,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRhFactor = newValue!;
                          });
                        },
                        items: rhFactors.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: hospitalLocationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: 'Hospital Location',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: medicalInformationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                    hintText: 'Medical Information',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: TextButton(
                  onPressed: () async {
  try {
    // Send the user's details to the server
    final response = await http.post(
      Uri.parse('https://elifesaver.online/includes/create_blood_appeal.inc.php'),
      body: {
        'user_type': widget.userType,
        'patient_id': patientId.toString(),
        'donor_id': widget.userId.toString(),
        'number_of_bags': numberOfBags.toString(),
        'blood_group': selectedBloodGroup,
        //'rhFactor': selectedRhFactor,
        'health_facility': hospitalLocationController.text,
        'medical_info': medicalInformationController.text,
      },
    );

    // Check if the response status code is successful (2xx range)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Get the content type from response headers
      final contentType = response.headers['content-type'];

      if (contentType != null && contentType.contains('application/json')) {
        // Convert the response to JSON format
        final jsonData = json.decode(response.body);

        print('Response JSON: $jsonData');

        // Check if the request was successful based on the response JSON
        final bool success = jsonData['success'] ?? false;

        if (success == true) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Blood Appeal successful'),
              content: Text(
                  'Appeal successfully created!.'),
              actions: [
                 TextButton(
        onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Dashboard(
        userName: widget.userName,
          phoneNumber: widget.phoneNumber,
          address: widget.address,
          city: widget.city,
          password: widget.password,
          btsNumber: widget.btsNumber,
          email: widget.email,
        userId: widget.userId,
        userType: widget.userType,
        bloodGroup: widget.bloodGroup,
      ),
    ),
    (route) => false, // Route predicate that removes all previous routes
  );
},
        child: Text(
          'OK',
          style: TextStyle(color: Colors.red),
        ),
      ),

              ],
            );
          },
        );
          // Check if the 'user' field is available and is a map
          if (jsonData['user'] is Map<String, dynamic>) {
            final Map<String, dynamic> user = jsonData['user'];
            final int userId = user['id'];
            final userType = jsonData['type'];
            final userName = user[userType + '_name'];
            print('User ID: $userId');
            print('User Name: $userName');

            // Request was successful, do what you need with the data
            // For example, show a success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Appeal successfully created!')),
            );
            Navigator.pop(context);
          } else {
            // 'user' field is not available or not a map
            print('Invalid user data format');
          }
        } else {
          // Request was not successful
          print('Request was not successful');
        }
      } else {
        // Response content type is not JSON
        print('Response content type is not JSON');
      }
    } else {
      // Response status code is not in the 2xx range
      print('Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  } catch (error) {
    // Handle any other errors that may occur during the HTTP request
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred. Please try again later.')),
    );
  }
},

       child: Text(
    'Finish',
    style: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  ),
),         ),
              
            ],
          ),
        ),
      ),
    );
  }
}
