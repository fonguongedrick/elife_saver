import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;
  String userType = prefs.getString('userType') ?? '';
  int userId = prefs.getInt('userId') ?? 0;
  String userName = prefs.getString('userName') ?? '';

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProfileDataNotifier(),
      child: MyApp(loggedIn: loggedIn, userType: userType, userId: userId, userName: userName),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool loggedIn;
  final String userType;
  final int userId;
  final String userName;

  MyApp({required this.loggedIn, required this.userType, required this.userId, required this.userName});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/e_life_saver.png'),
              Text(
                'WELCOME',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red,
        onPressed: () {
          // Go to the next screen.
          Provider.of<ProfileDataNotifier>(context, listen: false)
              .updateProfileData(ProfileData("Some data")); // Update profile data here
          pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/blood_test.png'),
            SizedBox(height: 80),
            Text('Where Donors and Patients meet', style: TextStyle(fontSize: 15),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red,
        onPressed: () {
          // Go to the next screen.
          pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

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

              SizedBox(height:100),
              Image.asset('assets/blood.png'),
              Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: Text(
                  'Find a compatible blood donor anytime, anywhere with ease',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red,
        onPressed: () {
          // Go to the login page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}