import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController bagsOfBloodController = TextEditingController(text: '2');
  final TextEditingController hospitalLocationController = TextEditingController();
  final TextEditingController medicalInfoController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();
  DateTime? _selectedDate;
   String bloodGroupValue = '';
  String factorValue = '';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateOfBirthController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',];  String selectedBloodGroup = 'A+';
  final List<String> rhFactors = ['Positive', 'Negative'];
  String selectedRhFactor = 'Positive';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Blood',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/Blood test-amico.png',
                  height: 150.0,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateOfBirthController,
                      decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Bags of blood'),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        int currentValue = int.tryParse(bagsOfBloodController.text) ?? 0;
                        if (currentValue > 1) {
                          currentValue--;
                          bagsOfBloodController.text = currentValue.toString();
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: bagsOfBloodController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Bags of Blood',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        int currentValue = int.tryParse(bagsOfBloodController.text) ?? 0;
                        currentValue++;
                        bagsOfBloodController.text = currentValue.toString();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Blood Group',),
                   DropdownButton<String>(
                      value: bloodGroupValue,
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.red,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          bloodGroupValue = newValue!;
                        });
                      },
                      items: <String>[
                        '',
                        'A+',
                        'B+',
                        'O+',
                        'AB+',
                        'A-',
                        'B-',
                        'O-',
                        'AB-'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select Rh Factor',),
                    DropdownButton<String>(
                  value: factorValue,
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      factorValue = newValue!;
                    });
                  },
                  items: <String>[
                    '',
                    'Rh+',
                    'Rh-',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: hospitalLocationController,
                    decoration: InputDecoration(
                      hintText: 'Hospital Location',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: medicalInfoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Medical Information',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Request'),
                style: ElevatedButton.styleFrom(
    primary: Colors.red,
  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}