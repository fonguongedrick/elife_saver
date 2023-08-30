import 'package:flutter/material.dart';
import 'vaccines.dart';
import 'results.dart';
import 'profile.dart';
import 'notification.dart';
import 'request_blood.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donor_appeal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dashboard extends StatefulWidget {
 final int userId;
  final String userName;
  final String userType;
  final String phoneNumber;
  final String email;
  final String city;
  final String address;
  final String password;
  final String btsNumber;
  final String bloodGroup;
  final String gender;
  Dashboard({required this.userId, required this.userName, required this.userType, required this.phoneNumber,
    required this.email,
    required this.city,
    required this.address,
    required this.password,
    required this.btsNumber,
    required this.bloodGroup,
    required this.gender});
  

 
  @override
  _DasboardState createState() => _DasboardState();
}

class _DasboardState extends State<Dashboard> {
  int? _credits;
  String _lastDonationDate = '';
String _nextDonationDate = '';
  void _onLoginSuccess(BuildContext context, String userName, int userId, String userType) {
    // After successful login, navigate to the PatientDashboard and pass the userId and userType
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
  try {
    // Clear user authentication data (example using SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // Replace 'accessToken' with your actual token key

    // After clearing the data, navigate the user back to the login screen
               _onLoginSuccess(context, widget.userName, widget.userId, widget.userType);

  } catch (error) {
    // Handle any errors that might occur during the logout process
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
        Future<void> fetchCredits() async {
  try {
    // Make a GET request to the server
    final response = await http.get(Uri.parse('https://elifesaver.online/donor/includes/get_credit.inc.php?bts_number=${widget.btsNumber}'));

    if (response.statusCode == 200) {
  final body = json.decode(response.body);
  final credits = body['credit'];
  final success = body['success'];
   print(success);
    print(credits);
  if (credits != null) {
    setState(() {
      _credits = credits;
    });
  } else {
    throw Exception('Failed to parse credits');
  }
} else {
  throw Exception('Failed to fetch credits');
}
} catch (error) {
throw Exception('Failed to fetch credits: $error');
}
}

 Future<void> _fetchDonationsData() async {
  try {
    final id = widget.userId;
    final gender = widget.gender;
    final url = Uri.parse('https://elifesaver.online/includes/get_donation_info.inc.php?id=${id ?? ""}&gender=${gender ?? ""}');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    print(gender);
    print(id);

    final jsonData = jsonDecode(response.body);
    print(jsonData['success']);

    if (jsonData['success'] == true) {
      print(jsonData);
      final lastDonationDate = jsonData['lastDonationDate'];
      final nextDonationDate = jsonData['nextDonationDate'];

      setState(() {
        _lastDonationDate = lastDonationDate;
        _nextDonationDate = nextDonationDate;
      });
    
    } else {
      print('Failed to fetch results');
    }
  } catch (error) {
    print('Error during API call: $error');
  }
}

@override
void initState() {
  super.initState();
  _fetchDonationsData();
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
  theme: ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black)

    ),
  ),
    home:Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Dashboard',
        style: TextStyle(color: Colors.black),),
        centerTitle: true,
        // Change the leading widget to a menu icon
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.notifications,
                color: Colors.red,
              ),
              onPressed: () {
               Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationPage(
      userId: widget.userId,
      userType: widget.userType,
      btsNumber: widget.btsNumber,
      bloodGroup:widget.bloodGroup,
      city:widget.city,
      address:widget.address
    ),
  ),
); // Handle notification button press
              },
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.bloodtype,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonorAppealPage(userId: widget.userId, userType: widget.userType, userName: widget.userName,
          phoneNumber: widget.phoneNumber,
          address: widget.address,
          city: widget.city,
          password: widget.password,
          btsNumber: widget.btsNumber,
          email: widget.email,
          bloodGroup: widget.bloodGroup,
          gender:widget.gender)),
    );// Handle notification button press
              },
            ),
            
          ],
      ),
      // Add a Drawer widget to the Scaffold
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(0),
          color: Colors.grey[300],
          child: Column(
            
            children: [
               // Add a DrawerHeader widget
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
      MaterialPageRoute(builder: (context) => Dashboard(userId: widget.userId, userName: widget.userName, userType: widget.userType, phoneNumber: widget.phoneNumber, address: widget.address, city: widget.city, password: widget.password, btsNumber: widget.btsNumber, email: widget.email, bloodGroup: widget.bloodGroup,  gender:widget.gender)),
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
              // Add Drawer items
ListTile(
  title: Row(
    children: [
      Icon(Icons.local_hospital, color: Colors.red),
      SizedBox(width: 10),
      Text('Blood Appeal'),
    ],
  ),
  onTap: () {
    // Example code for navigation from the registration page
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonorAppealPage(userId: widget.userId, userType: widget.userType, userName: widget.userName,
          phoneNumber: widget.phoneNumber,
          address: widget.address,
          city: widget.city,
          password: widget.password,
          btsNumber: widget.btsNumber,
          email: widget.email,
          bloodGroup: widget.bloodGroup,
           gender:widget.gender)),
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
    // Inside the Dashboard widget, where you have the navigation to NotificationPage
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationPage(
      userId: widget.userId,
      userType: widget.userType,
      btsNumber: widget.btsNumber,
      bloodGroup:widget.bloodGroup,
      city:widget.city,
      address:widget.address
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
      Text('Vaccines'),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VaccinesPage(userId:widget.userId,)),
    );
  },
),
ListTile(
  title: Row(
    children: [
      Icon(Icons.assignment, color: Colors.red),
      SizedBox(width: 10),
      Text('Results'),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(btsNumber:widget.btsNumber)),
    );
  },
),

ListTile(
  title: Row(
    children: [
      Icon(Icons.person, color: Colors.red),
      SizedBox(width: 10),
      Text('My Account'),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(userId:widget.userId, userName: widget.userName,
          phoneNumber: widget.phoneNumber,
          address: widget.address,
          city: widget.city,
          password: widget.password,
          btsNumber: widget.btsNumber,
          email: widget.email,
        )),
    );
  },
),
SizedBox(height: 185,),
Padding(
  padding: const EdgeInsets.only(left:28.0, bottom : 10),
  child: Align(
    alignment: Alignment(0,-100),
    child: ListTile(
     titleAlignment: ListTileTitleAlignment.bottom,
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
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          
            child: SingleChildScrollView(
              child: Column(
                children: [
                 Align(
                  alignment: Alignment.centerRight,
                   child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                               showDialog(
                               context: context,
                               builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        contentPadding: EdgeInsets.all(16.0),
                        content: Container(
                          padding: EdgeInsets.only(left:12),
                          height: 250,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.notification_important,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 16),
                                Expanded(
                                  child: Text(
                                    'Get credits for accepting blood request and donating.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Your credits can be used to subsidize medical expenses or redeemed to gifts',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(height: 16),
                                         
                                 Text('Elifesaver',
                                   style: TextStyle(fontWeight: FontWeight.bold),),       ],
                                                      ),
                          ),
                        ),
                                                ));
                                              },
                                            ); 
                              },
                              child: Text(
                                             '${_credits ?? '0'}',
                                             style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color:Colors.red),
                                ),
                            ),
                            Text(
                              'Credits',
                              style: TextStyle(fontSize: 16.0),
                              
                            ),
                          ]),
                 ),
                  Row(
                    children: [
                      Text('Hello'),
                  SizedBox(width:6),
                  Text('${widget.userName}',style: TextStyle(color:Colors.red, fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(height:8),
                  Row(
                    children: [
                      Text('Bts Number : '),
                  SizedBox(width:6),
                  Text('${widget.btsNumber}', style: TextStyle(color:Colors.red, fontWeight: FontWeight.bold),)
                      
                    ],
                  ),
                  
                          SizedBox(height: 30,),
                  
                          Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.red, width: 1.0),
                          ),
                          width: 350,
                          height: 160,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Last Donation',
                                  style: TextStyle(fontSize: 16.0, color: Colors.red),
                                ),
                              ),
                              SizedBox(height: 20),
                          
                              Text(
                                _lastDonationDate.isNotEmpty ? _lastDonationDate : 'No Donation yet',
                                style: TextStyle(fontSize: 19.0),
                              ),
                              SizedBox(height: 5),
                              
                              Container(
                                
                                width: 240,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextButton(
                                onPressed: () {
                                 showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: AlertDialog(
                                          contentPadding: EdgeInsets.all(16.0),
                                          content: Container(
                                            height: 250,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.cancel),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Icon(
                                                Icons.notification_important,
                                                size: 40,
                                                color: Colors.red,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Donate Blood to Gain credits',
                                                style: TextStyle(fontSize: 16),
                                                
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                    
                                                    'Reaction:',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(width: 4,),
                                                  if (_lastDonationDate == '') 
                                                  Expanded(child: Text('You have not perfomed any donation yet.'))
                                                  else
                                                  Text('Your blood was used to save a life.')
                                                ],
                                              ),
                                                 SizedBox(height: 18,),
                                               Text('Elifesaver',
                                                 style: TextStyle(fontWeight: FontWeight.bold),),       ],
                                                                    ),
                                          ),
                                              ));
                                            },
                                          ); // ...
                                },
                                child: Text(
                                  'Learn more',
                                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                                ),
                                ),
                              ),
                            ],
                          ),
                          ),
                SizedBox(height: 30,),
              // ...
              
               Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red, width: 1.0),
                ),
                width: 350,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                'Next Donation',
                style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                       
                    Text(
                      _nextDonationDate.isNotEmpty ? _nextDonationDate : 'No Donation yet',
                      style: TextStyle(fontSize: 19.0),
                    ),
                    SizedBox(height: 5),
                    
                    Container(
                      width: 240,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                      onPressed: () {
                       showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: AlertDialog(
                        contentPadding: EdgeInsets.all(16.0),
                        content: Container(
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.notification_important,
                                size: 40,
                                color: Colors.red,
                              ),
                              SizedBox(height: 16),
                                 if (widget.gender == 'male') 
                                   Expanded(child: Text('After donating, you need to wait for up to 3 months before you can donate again. see you soon'),)
                                   else
                                   Expanded(child: Text('After donating, you need to wait for up to 4 months before you can donate again. see you soon')),
                                 SizedBox(height: 6,),
                                 Text('Elifesaver',
                                 style: TextStyle(fontWeight: FontWeight.bold),),               
                                                  ],
                                                    ),
                        ),
                                                ));
                                              },
                                            ); // ...
                      },
                      child: Text(
                'Learn more',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      ),
                    ),
                  ],
                ),
                       ),
                          SizedBox(height: 30,),
                          Container(
                            height: 80,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.red, width: 1.0),
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: (){
                                   Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ResultPage(btsNumber:widget.btsNumber)),
                                      );
                                },
                                child: Text(
                                  'Results',
                                  style: TextStyle(fontSize: 19.0, color: Colors.black),
                                ),
                              ),
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