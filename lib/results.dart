import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  if (dateString.isEmpty) {
    return 'N/A';
  }

  final parsedDate = DateTime.parse(dateString);
  return DateFormat('dd/MM/yy').format(parsedDate);
}
class ResultPage extends StatefulWidget {
  final String btsNumber;
  ResultPage({required this.btsNumber});
  
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
     try {
      final btsNumber = widget.btsNumber;
      
      // Check if btsNumber is null and provide a default value (an empty string)
      final url = Uri.parse('https://elifesaver.online/includes/get_all_donor_results.inc.php?bts_number=${btsNumber ?? ""}');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
        // You can pass the 'bts_number' as a query parameter in the URL
        // If the server expects the 'bts_number' as part of the URL, modify the endpoint accordingly
        // For example: 'https://example.com/api/get_results?bts_number=${widget.btsNumber}'
        // Otherwise, if it's part of the headers or body, you can include it here.
        // For example, if it's part of the headers: 'Authorization': 'Bearer ${widget.btsNumber}'
        // If it's part of the body, you can pass it as a parameter like in the POST method.
      
print(btsNumber);
final jsonData = json.decode(response.body);
        final bool success = jsonData['success'];
  print(jsonData);
  print(success);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bool success = jsonData['success'];

        if (success) {
          final List<dynamic> resultsData = jsonData['results'];
          List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(resultsData);

          setState(() {
            _results = results;
          });
        } else {
          setState(() {
            _results = [];
          });
        }
      } else {
        print('Failed to fetch results');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results',
          style: const TextStyle(
            color: Colors.black,
            
          ),
          
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40,),             
              Row(
                children: [
                  Expanded(
                    child: Text('Blood Donors Test Results',
                    style:TextStyle(fontSize: 24,
                    color: Colors.red)),
                  ),
                  SizedBox(width: 15,),
                  Column(
                    children: [
                      Text('Last Date of Test '),
                          for (final result in _results)
                      Text(formatDateString(result['date'] ?? ''))
                    ],
                  )
                ],
              ),
              SizedBox(height: 50,),
            Text('Serology: Predonation: RDT',
                    style:TextStyle(fontSize: 24,
                    color: Colors.red)), 
              SizedBox(height: 20,),
                    // Check if _results is empty
              _results.isEmpty
                  ? Center(
                      child: Text(
                        'No results available yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Expanded(
                  // Use a Table to display the results in a tabular format
                  child: Column(
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          // Table headings
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'HCV',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'HBAg',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'HIV',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                             
                            ],
                          ),
                          // Display the test results in each row
                          for (final result in _results)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.grey[300],
                                    child: Text(
                                      result['HCV'] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.grey[300],
                                    child: Text(
                                      result['HBAg'] ?? 'N/A',
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        result['HIV'] ?? 'N/A',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 15,),
                       Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2:FlexColumnWidth(2)
                    },
                    children: [
                      // Table headings
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Weight',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'bp_up',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'bp_down',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                      // Display the test results in each row
                      for (final result in _results)
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['weight']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['bp_up']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Center(
                                  child: Text(
                                    result['bp_down']?.toString() ?? 'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                    ],
                  ),
                    SizedBox(height: 15,),
                       Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2:FlexColumnWidth(2)
                    },
                    children: [
                      // Table headings
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'hb',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'HCV_elisa',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'HBsAg_elisa',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                      // Display the test results in each row
                      for (final result in _results)
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['hb']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['HCV_elisa']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Center(
                                  child: Text(
                                    result['HBsAg_elisa']?.toString() ?? 'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                    ],
                  ),
                   SizedBox(height: 15,),
                       Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(2),
                      2:FlexColumnWidth(1.5)
                    },
                    children: [
                      // Table headings
                      TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'HIV_elisa',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Observation',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Date',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                      // Display the test results in each row
                      for (final result in _results)
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['HIV_elisa']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Text(
                                  result['observation']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.grey[300],
                                child: Center(
                                  child: Text(
                                    formatDateString(result['date'] ?? ''),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                    ],
                  ), ],
                  ),
                ),
          ],
        ),
      )));
  
  }
}
