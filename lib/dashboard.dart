import 'package:flutter/material.dart';
import 'vaccines.dart';
import 'results.dart';
import 'profile.dart';
import 'notification.dart';
import 'request_blood.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donor_appeal.dart';

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
  Dashboard({required this.userId, required this.userName, required this.userType, required this.phoneNumber,
    required this.email,
    required this.city,
    required this.address,
    required this.password,
    required this.btsNumber,
    required this.bloodGroup});
  

 
  @override
  _DasboardState createState() => _DasboardState();
}

class _DasboardState extends State<Dashboard> {
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
                // Handle notification button press
              },
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.bloodtype,
                color: Colors.red,
              ),
              onPressed: () {
                // Handle notification button press
              },
            ),
            SizedBox(width: 1,),
            IconButton(
              padding: EdgeInsets.zero,
              icon: CircleAvatar(
             child: Icon(Icons.person, color: Colors.grey,),
             backgroundColor: Colors.white,
              ),
              onPressed: () {
                // Handle profile button press
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
      MaterialPageRoute(builder: (context) => Dashboard(userId: widget.userId, userName: widget.userName, userType: widget.userType, phoneNumber: widget.phoneNumber, address: widget.address, city: widget.city, password: widget.password, btsNumber: widget.btsNumber, email: widget.email, bloodGroup: widget.bloodGroup)),
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
          bloodGroup: widget.bloodGroup)),
    );
  },
), 
ListTile(
  title: Row(
    children: [
      Icon(Icons.favorite, color: Colors.red),
      SizedBox(width: 10),
      Text('Blood request'),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RequestPage()),
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
          email: widget.email,)),
    );
  },
),
SizedBox(height: 20,),
Padding(
  padding: const EdgeInsets.all(18.0),
  child:   ListTile(
  
    title: Row(
  
      children: [
  
        Icon(Icons.logout, color: Colors.red),
  
        SizedBox(width: 10),
  
        TextButton(onPressed: (){
           logoutUser(context); 
        }, child: Text('Logout',
        style: TextStyle(color:Colors.black)))
  
      ],
  
    ),
  
    onTap: () {
  
     
    },
  
  ),
),
            
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              Text('Hi, ${widget.userName}!'),
              Align(
                  alignment: Alignment.centerRight,
                child: SizedBox(
                     
                  child: Container(
                    child: Column(
                      children: [
                        
                        Text(
                          '1500',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'Credits',
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 30,),
                
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.red, width: 6.0),
                          ),
                          width: 350,
                          
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '21/05/2023',
                                style: TextStyle(fontSize: 19.0),
                              ),
                              SizedBox(height:10),
                              Text(
                                'Last Donations',
                                style: TextStyle(fontSize: 16.0),
                              ),
                               SizedBox(height: 5,),
                              Align(
                                  alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Learn more',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          height: 100,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(19.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  '21/08/2023',
                                  style: TextStyle(fontSize: 19.0,
                                  color: Colors.white),
                                ),
                                SizedBox(height: 8,),
                                Text(
                                  'Next Donation',
                                  style: TextStyle(fontSize: 16.0,
                                  color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          height: 100,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.red, width: 6.0),
                          ),
                          child: Center(
                            child: Text(
                              'Results',
                              style: TextStyle(fontSize: 19.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                        
                        ),
                ),
                    
                  ),
            ],
          ),
            ),
      ),
        )
      );
     
    
  }
}