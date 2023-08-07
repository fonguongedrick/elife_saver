import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient_dashboard.dart';

class HospitalLocation {
  final int id;
  final String name;

  HospitalLocation({required this.id, required this.name});

  factory HospitalLocation.fromJson(Map<String, dynamic> json) {
    return HospitalLocation(
      id: json['id'],
      name: json['name'],
    );
  }
}

class MakeAppealPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userType;

  MakeAppealPage({required this.userId, required this.userName, required this.userType});

  @override
  _MakeAppealPageState createState() => _MakeAppealPageState();
}

class _MakeAppealPageState extends State<MakeAppealPage> {
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String selectedBloodGroup = 'A+';
  final List<String> rhFactors = ['Positive', 'Negative'];
  String selectedRhFactor = 'Positive';
  int numberOfBags = 2;
  int? donorId;
  late List<HospitalLocation> hospitalLocations;
  HospitalLocation? selectedHospitalLocation;
  final hospitalLocationController = TextEditingController();
  final medicalInformationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hospitalLocations = [];
    fetchHospitalLocations();
  }

  @override
  void dispose() {
    hospitalLocationController.dispose();
    medicalInformationController.dispose();
    super.dispose();
  }

  int max(int a, int b) {
    return a > b ? a : b;
  }

  Future<void> fetchHospitalLocations() async {
    try {
      final response = await http.get(
        Uri.parse('https://elifesaver.online/includes/get_all_health_facilities.inc.php'), // Replace with your actual API endpoint
      );
        final jsonData = json.decode(response.body);
        print(jsonData);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          final List<dynamic> facilities = jsonData['health_facilities'];
          setState(() {
            hospitalLocations = facilities.map((item) => HospitalLocation.fromJson(item)).toList();
          });
        } else {
          print('Error: ${jsonData['message']}');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
                child: DropdownButton<HospitalLocation>(
                  value: selectedHospitalLocation,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (HospitalLocation? newValue) {
                    setState(() {
                      selectedHospitalLocation = newValue;
                    });
                  },
                  items: hospitalLocations.map<DropdownMenuItem<HospitalLocation>>((HospitalLocation location) {
                    return DropdownMenuItem<HospitalLocation>(
                      value: location,
                      child: Text(location.name),
                    );
                  }).toList(),
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
                          'patient_id': widget.userId.toString(),
                          'donor_id': donorId.toString(),
                          'number_of_bags': numberOfBags.toString(),
                          'blood_group': selectedBloodGroup,
                          'rhFactor': selectedRhFactor,
                          'health_facility': selectedHospitalLocation?.name ?? hospitalLocationController.text,
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
                                  content: Text('Appeal successfully created!.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Navigate to the PatientDashboard and remove all the previous screens from the stack
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PatientDashboard(
                                              userName: widget.userName,
                                              userId: widget.userId,
                                              userType: widget.userType,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
