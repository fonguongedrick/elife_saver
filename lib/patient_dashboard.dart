import 'package:flutter/material.dart';
import 'notification.dart';
import 'donor_info.dart';
import 'login.dart';
import 'patient_notification.dart';
import 'make_appeal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PatientDashboard extends StatefulWidget {
  final int userId;
  final String userName;
  final String userType;

  PatientDashboard({required this.userId, required this.userName, required this.userType});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  List<Map<String, dynamic>> _bloodAppeals = [];
   bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchBloodAppeals();
  }

 Future<void> _fetchBloodAppeals() async {
  setState(() {
      _isLoading = true;
      
    });
  try {
    final url = Uri.parse('https://elifesaver.online/includes/get_all_blood_appeals_for_user.inc.php');
    final response = await http.post(
      url,
      body: {
        'id': widget.userId.toString(),
        'user_type': widget.userType,
      },
    );
      setState(() {
      _isLoading = false;
      
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final bool status = jsonData['success'];
      print(status);
      // Print the response data on the console
      print('Response: $jsonData');

      if (status) {
        final bloodAppealsData = jsonData['blood_appeals'];
        List<Map<String, dynamic>> bloodAppeals = List<Map<String, dynamic>>.from(bloodAppealsData);

        setState(() {
          _bloodAppeals = bloodAppeals;
        });
      } else {
        setState(() {
          _bloodAppeals = [];
        });
      }
    } else {
      print('Failed to fetch blood appeals');
    }
  } catch (error) {
    print('Error during API call: $error');
  }
}

  Future<void> logoutUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (error) {
      print('Error during logout: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Error'),
            content: Text('An error occurred while logging out. Please try again.'),
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
  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear the login state and user information from SharedPreferences
    await prefs.clear();

    // Navigate the user back to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Dashboard',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.black,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', height: 100, width: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PatientDashboard(userId: widget.userId, userName: widget.userName, userType: widget.userType)),
                            );
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.dashboard, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Dashboard'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientDashboard(userId: widget.userId, userName: widget.userName, userType: widget.userType)),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.local_hospital, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Blood Appeal'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeAppealPage(userId: widget.userId, userName: widget.userName, userType: widget.userType)),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Notification'),
                  ],
                ),
                onTap: () {
                 Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientNotification(
            userId: widget.userId,
            userName: widget.userName,
            userType: widget.userType,
          ),
        ),
      );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.local_hospital, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Become a Donor'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonorInfoPage()),
                  );
                },
              ),
              SizedBox(height: 240,),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                onTap: () {
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
                    'Logging out...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
                          ),
                        ),
                      );
                    },
                  );
              
                  Future.delayed(Duration(seconds: 3), () {
                    logout(context);
                    Navigator.pop(context); // Close the dialog
                  });
                },
              ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hi',
                            
                          ),
                          SizedBox(width: 5,),
                          Text('${widget.userName}!',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),)
                        ],
                      ),
                      // ... (rest of your user info code)
                    ],
                  ),
                ),
                SizedBox(height: 30),
                if (_bloodAppeals.isNotEmpty)
              ..._bloodAppeals.map((appeal) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:_isLoading
                ? SpinKitFadingCircle(
        color: Colors.red, // Choose your desired color
        size: 50.0, // Choose your desired size
      )  :  Container(
                       padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Expanded(
                        child: Row(
                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${appeal['number_of_bags']} bags of ${appeal['blood_group'] ?? 'Unknown Blood Group'} needed at ${appeal['health_facility'] ?? 'Unknown Facility'}',
                                
                              ),
                            ),
                            SizedBox(width: 38),
                            Expanded(
                              child: Text(
                                '${appeal['creation_date']} Status: ${appeal['status']}',
                                
                              ),
                              
                            ),
                            
                          ],
                          
                        ),
                      ),
                    ),
              ))
            else
              _isLoading
                ? SpinKitFadingCircle(
        color: Colors.red, // Choose your desired color
        size: 30.0, // Choose your desired size
      )  : Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Text(
                  'No Blood Appeal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                SizedBox(height: 16),
                Container(
                  width:300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeAppealPage(userId: widget.userId, userName: widget.userName, userType: widget.userType)),
                  );// Handle the New Appeal button press.
                    },
                    child: Text(
                      'New Appeal',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
