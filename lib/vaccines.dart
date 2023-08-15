import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
bool _isLoading = false;
@override
void initState() {
super.initState();
_fetchVaccineData();
}

void _fetchVaccineData() async {
  setState(() {
      _isLoading = true; 
      // Hide progress indicator
    });
final response = await http.post(
Uri.parse('https://elifesaver.online/donor/includes/fetch_vaccines.inc.php'),
body: {
'id': widget.userId.toString(),
},
);
setState(() {
      _isLoading = false; 
      // Hide progress indicator
    });
if (response.statusCode == 200) {
final jsonData = jsonDecode(response.body);
final success = jsonData['success'];
final dateList = jsonData['date'] as List<dynamic>;
final vaccineResponse = jsonData['vaccine_response'];

print('Success: $success');
print('Date List: $dateList');
print('Vaccine Response: $vaccineResponse');

if (success) {
  List<Map<String, dynamic>> dates = dateList
      .map((dateJson) => {'dose_date': dateJson['dose_date'], 'status': 'Taken'})
      .toList();

  setState(() {
    _dates = dates;
    final vaccinesData = vaccineResponse as List<dynamic>;
    List<Vaccine> vaccines = vaccinesData
        .map((vaccineJson) => Vaccine.fromJson(vaccineJson as Map<String, dynamic>))
        .toList();

    _vaccines = vaccines;
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

// Extract the date strings from the doses
List<String> dates = doses.map((date) => DateFormat('MMM d, yyyy').format(DateTime.parse(date['dose_date']))).toList();

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
    centerTitle: true,
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
       SizedBox(height: 50,),
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
        _isLoading
        ? SpinKitCircle(
                            color: Colors.red,
                            size: 30.0,
                          )
       : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dates.length >= 3
                ? [
                    Text(
                      DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 3]['dose_date'])),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 2]['dose_date'] )) ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
  _dates.isNotEmpty ? DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 1]['dose_date'])) : 'No Dose',
  style: TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  ),
  ),
  ]
  : [],
  ),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  if (_dates.length > 3)
  Text(
  DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 3]['dose_date'])),
  style: TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  ),
  )
  else
  
  Text(
  'No Dose',
  style: TextStyle(
  color: Colors.black,
  fontSize: 16.0,
  ),
  ),
              if (_dates.length > 2)
                Text(
                  DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 2]['dose_date'])),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              else
                Text(
                  'No Dose',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              
              if (_dates.length > 1)
                Text(
                  DateFormat('MMM d, yyyy').format(DateTime.parse(_dates[_dates.length - 1]['dose_date'])),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              else
                Text(
                  'No Dose',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
            ],
          ),
        ),
        
  // Add the same code for '2nd Dose' and '3rd Dose' here...
        /*Align(
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
        ),*/
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Vaccine Name',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Status',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
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