import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class VaccinesPage extends StatefulWidget {
  final int userId;

  const VaccinesPage({required this.userId});

  @override
  _VaccinesPageState createState() => _VaccinesPageState();
}


class _VaccinesPageState extends State<VaccinesPage> {
  List<Vaccine> _vaccines = [];
  List<String> _doses = ['1st Dose', '2nd Dose', '3rd Dose'];
  List<Map<String, dynamic>> _dates = [];

  @override
  void initState() {
    super.initState();
    _fetchVaccineData();
  }

  void _fetchVaccineData() async {
    final response = await http.post(
      Uri.parse('https://elifesaver.online/donor/includes/fetch_vaccines.inc.php'),
      body: {
        'id': widget.userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final success = jsonData['success'];
      final dateList = jsonData['date'] as List<dynamic>; // Corrected key name
      final vaccineResponse = jsonData['vaccine_response'];

      print('Success: $success');
      print('Date List: $dateList');
      print('Vaccine Response: $vaccineResponse');

      if (success) {
        List<Map<String, dynamic>> dates = dateList
            .map((dateJson) => {'dose_date': dateJson['dose_date'], 'status': 'Taken'})
            .toList();

        setState(() {
          _dates = dates; // Store the dates in the _dates variable
          final vaccinesData = vaccineResponse as List<dynamic>;
          List<Vaccine> vaccines = vaccinesData
              .map((vaccineJson) => Vaccine.fromJson(vaccineJson as Map<String, dynamic>))
              .toList();

          _vaccines = vaccines;

          // Call _getDatesForDose here to update the UI with the correct dates
        });
      } else {
        print('Failed to fetch vaccine data');
      }
    } else {
      print('Failed to fetch vaccine data');
    }
  }

  List<String> _getDatesForDose(String doseName) {
  List<Map<String, dynamic>> doses = _dates
      .where((date) =>
          _vaccines.any((vaccine) => vaccine.vaccineName == doseName && vaccine.date == date['dose_date']))
      .toList();

  // Sort the doses by date in ascending order
  doses.sort((a, b) => DateTime.parse(a['dose_date']).compareTo(DateTime.parse(b['dose_date'])));

  // Take the last three doses
  List<Map<String, dynamic>> lastThreeDoses = doses.reversed.take(3).toList();

  // Extract the date strings from the doses
  List<String> dates = lastThreeDoses.map((date) => date['dose_date'] as String).toList();

  return dates;
}



  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Vaccines',
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
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hep B',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _doses
                    .map(
                      (dose) => Text(
                        dose,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
         Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (int i = 0; i < _doses.length; i++)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _doses[i],
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _getDatesForDose(_doses[i]).length,
              itemBuilder: (context, index) {
                String date = _getDatesForDose(_doses[i])[index];
                return Text(
                  date,
                  style: TextStyle(fontSize: 16.0),
                );
              },
            ),
          ],
        ),
      ),
  ],
),

// Add the same code for '2nd Dose' and '3rd Dose' here...

            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Download',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Vaccine Name',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Status',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    ..._vaccines.map((vaccine) {
                      return TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              vaccine.vaccineName,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              vaccine.status,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Vaccine {
  final String vaccineName;
  final String status;
  final String date;

  Vaccine({
    required this.vaccineName,
    required this.status,
    required this.date,
  });

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      vaccineName: json['vaccine_name'] ?? '',
      status: json['status'] ?? '',
      date: json['dose_date'] ?? '',
    );
  }
}
