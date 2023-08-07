import 'package:flutter/material.dart';
class DonorInfoPage extends StatefulWidget {
  @override
  State<DonorInfoPage> createState() => _DonorInfoPageState();
}

class _DonorInfoPageState extends State<DonorInfoPage> {
  bool isMaleActive = true;
  String? userName;

  void toggleGender(bool isMale) {
    setState(() {
      isMaleActive = isMale;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Donor Information', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/blood_appeal.png',
                  height: 150.0,
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Text(
                    'Send User by',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => toggleGender(true),
                    child: CircleAvatar(
                      backgroundColor: isMaleActive ? Colors.red : Colors.grey,
                      radius: 6,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'BTS',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => toggleGender(false),
                    child: CircleAvatar(
                      backgroundColor: !isMaleActive ? Colors.red : Colors.grey,
                      radius: 6,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
            child: Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'BTS number',
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 160,
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
            child: Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter patients nedical information',
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            /*child: TextButton(
              onPressed: () {
                void _onLoginSuccess(BuildContext context, String userName, int userId, String userType) {
  // After successful login, navigate to the DonorDashboard and pass the userId and userType
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Dashboard(userName:userName, userId: userId, userType: userType),
    ),
  );
}
              },
              child: Text(
                'Finish',
                style: TextStyle(color: Colors.white),
              ),
            ),*/
          ),
              ],
            ),
        ),
      ),
    );
  }
}