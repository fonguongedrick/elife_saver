import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'patient_dashboard.dart';
class ProfileData {
String data;

ProfileData(this.data);
}

class ProfileDataNotifier extends ChangeNotifier {
  ProfileData? _profileData;

  ProfileData get profileData => _profileData!;

  set profileData(ProfileData profileData) {
    _profileData = profileData;
    notifyListeners();
  }

  void updateProfileData(ProfileData profileData) {
    _profileData = profileData;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkLoginStatus();
}

Future<void> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('LoggedIn') ?? false;
  String userType = prefs.getString('userType') ?? '';
  int userId = prefs.getInt('userId') ?? 0;
  String userName = prefs.getString('userName') ?? '';
  String phoneNumber = prefs.getString('phoneNumber') ?? '';
  String address = prefs.getString('address') ?? '';
  String city = prefs.getString('city') ?? '';
  String password = prefs.getString('password') ?? '';
  String btsNumber = prefs.getString('btsNumber') ?? '';
  String email = prefs.getString('email') ?? '';
  String bloodGroup = prefs.getString('bloodGroup') ?? '';
  String gender = prefs.getString('gender') ?? '';

  if (loggedIn) {
    if (userType == 'patient') {
      runApp(
        ChangeNotifierProvider(
          create: (context) => ProfileDataNotifier(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: PatientDashboard(
              userId: userId,
              userName: userName,
              userType: userType,
            ),
          ),
        ),
      );
    } else if (userType == 'donor') {
      runApp(
        ChangeNotifierProvider(
          create: (context) => ProfileDataNotifier(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Dashboard(
              userId: userId,
              userName: userName,
              userType: userType,
              phoneNumber: phoneNumber,
              address: address,
              city: city,
              password: password,
              btsNumber: btsNumber,
              email: email,
              bloodGroup: bloodGroup,
              gender: gender,
            ),
          ),
        ),
      );
    }
  } else {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: My(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  final String userType;
  final int userId;
  final String userName;
  final String phoneNumber;
  final String address;
  final String city;
  final String password;
  final String btsNumber;
  final String email;
  final String bloodGroup;
  final String gender;

  MyApp({
    required this.loggedIn,
    required this.userType,
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.password,
    required this.btsNumber,
    required this.email,
    required this.bloodGroup,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      if (userType == 'patient') {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: PatientDashboard(
            userId: userId,
            userName: userName,
            userType: userType,
          ),
        );
      } else if (userType == 'donor') {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Dashboard(
            userId: userId,
            userName: userName,
            userType: userType,
            phoneNumber: phoneNumber,
            address: address,
            city: city,
            password: password,
            btsNumber: btsNumber,
            email: email,
            bloodGroup: bloodGroup,
            gender: gender,
          ),
        );
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: My(),
    );
  }
}


class My extends StatefulWidget {
 

  @override
  State<My> createState() => _My();
}

class _My extends State<My> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                FirstScreen(pageController: _pageController),
                MyFirstScreen(pageController: _pageController),
                MySecondScreen(pageController: _pageController),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PageIndicator(
                  totalDots: 3,
                  currentPage: _currentPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int totalDots;
  final int currentPage;

  PageIndicator({required this.totalDots, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  final PageController pageController;

  FirstScreen({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                // Go to the login page.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.red,),
              ),
            ),
          ),
          SizedBox(height: 100),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/e_life_saver.png', height:250, width:250,),
              Text(
                'WELCOME',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 80),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red,
        onPressed: () {
          // Go to the next screen.
          // Update profile data here
          pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class MyFirstScreen extends StatelessWidget {
  final PageController pageController;

  MyFirstScreen({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                // Go to the login page.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.red, ),
              ),
            ),
          ),
          SizedBox(
            height: 110,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/blood_test.png', height:250, width:250,),
              SizedBox(height:2,),
              Text(
                'Where Donors and Patients meet',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red,
        onPressed: () {
          // Go to the next screen.
          pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );}}
class MySecondScreen extends StatelessWidget {
  final PageController pageController;

  MySecondScreen({required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 135),
              Image.asset('assets/Blood test-bro.png', height:250, width:250),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  'Find a compatible blood donor anytime, anywhere with ease',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 150),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 40,
                  padding: EdgeInsets.all(1),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Get started',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}