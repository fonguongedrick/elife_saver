import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
 class PatientNotification extends StatefulWidget {
  final int userId;
  final String userName;
  final String userType;

  PatientNotification({required this.userId, required this.userName, required this.userType});

  @override
  State<PatientNotification> createState() => _PatientNotificationState();
}

class _PatientNotificationState extends State<PatientNotification> {
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
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Notification',
        style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child:Column(
              children: [
                if (_bloodAppeals.isNotEmpty)
                  ..._bloodAppeals.map((appeal) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:_isLoading
                    ? Center(
                      child: SpinKitFadingCircle(
                              color: Colors.red, // Choose your desired color
                              size: 50.0, // Choose your desired size
                            ),
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
          )  : Center(
            child: Container(
                  width: 350,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red[200],
                      ),
                      child: Text(
                        'No Blood Appeal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ),
                    
              ],
            )
          ),
        ),
      )
    );
  }
}