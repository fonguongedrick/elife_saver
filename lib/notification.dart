import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
   final int userId;
  final String userType;
  final String btsNumber;
  final String bloodGroup;

  NotificationPage({
    required this.userId,
    required this.userType,
    required this.btsNumber,
    required this.bloodGroup,
  });
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
        'user_type': widget.userType,
        'blood_group': widget.bloodGroup,
      },
    );
     final jsonData = json.decode(response.body);
      final bool status = jsonData['success'];
      print(status);
      // Print the response data on the console
      print('Response: $jsonData');
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
      print('Failed to fetch blood appeals. Status code: ${response.statusCode}');
      setState(() {
        _bloodAppeals = [];
      });
    }
  } catch (error) {
    print('Error during API call: $error');
    setState(() {
      _bloodAppeals = [];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification banner
            _bloodAppeals.isEmpty
                ? Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3F3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'No new notification',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 30),
            // List of blood appeals
            Expanded(
              child: ListView.builder(
                itemCount: _bloodAppeals.length,
                itemBuilder: (context, index) {
                  final bloodAppeal = _bloodAppeals[index];
                  final bloodGroup = bloodAppeal['blood_group'];
                  final numberOfBags = bloodAppeal['number_of_bags'];
                  final healthFacility = bloodAppeal['health_facility'];
                  final creationDate = DateTime.parse(bloodAppeal['creation_date']);
                  final status = bloodAppeal['status'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Blood group',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              '$numberOfBags bags of $bloodGroup needed at $healthFacility',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 66),
                          Expanded(
                            child: Text(
                              '${creationDate.day}/${creationDate.month}/${creationDate.year} ${creationDate.hour}:${creationDate.minute} status: $status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom row
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1/${_bloodAppeals.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 0.1,),
                  Icon(
                    Icons.arrow_left,
                    color: Colors.red,
                  ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  // Add more circles for each blood appeal item
                  for (int i = 2; i <= _bloodAppeals.length; i++)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(
                        i.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
