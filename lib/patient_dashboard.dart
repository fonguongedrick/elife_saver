import 'package:flutter/material.dart';
import 'notification.dart';
import 'donor_info.dart';
import 'login.dart';
import 'make_appeal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchBloodAppeals();
  }

 Future<void> _fetchBloodAppeals() async {
  try {
    final url = Uri.parse('https://elifesaver.online/includes/get_all_blood_appeals_for_user.inc.php');
    final response = await http.post(
      url,
      body: {
        'id': widget.userId.toString(),
        'user_type': widget.userType,
      },
    );
    
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
          actions: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey,),
            ),
            SizedBox(width: 16),
          ],
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
                    Image.asset('assets/e_life_saver.png', height: 100, width: 100,),
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
              SizedBox(height: 90,),
              Padding(
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
                    logoutUser(context);
                  },
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
                      width: 8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${widget.userName}!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ... (rest of your user info code)
                    ],
                  ),
                ),
                SizedBox(height: 30),
                if (_bloodAppeals.isNotEmpty)
              ..._bloodAppeals.map((appeal) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 68),
                            Expanded(
                              child: Text(
                                '${appeal['creation_date']} Status: ${appeal['status']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                            ),
                            
                          ],
                          
                        ),
                      ),
                    ),
              ))
            else
              Container(
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
