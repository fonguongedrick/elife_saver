import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int userId;
  final String userName;
  final String phoneNumber;
  final String email;
  final String city;
  final String address;
  final String password;
  final String btsNumber;

  ProfilePage({
    required this.userId,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.city,
    required this.address,
    required this.password,
    required this.btsNumber,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _emailController = TextEditingController(text: widget.email);
    _cityController = TextEditingController(text: widget.city);
    _addressController = TextEditingController(text: widget.address);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userName != widget.userName) {
      _nameController.text = widget.userName;
    }
    if (oldWidget.phoneNumber != widget.phoneNumber) {
      _phoneController.text = widget.phoneNumber;
    }
    if (oldWidget.email != widget.email) {
      _emailController.text = widget.email;
    }
    if (oldWidget.city != widget.city) {
      _cityController.text = widget.city;
    }
    if (oldWidget.address != widget.address) {
      _addressController.text = widget.address;
    }
    // Password field is not updated here as it should be empty by default.
    // It will only be updated when the user enters a new password.
  }
   String getInitials(String name) {
  List<String> nameParts = name.split(' ');
  String initials = '';

  for (String part in nameParts) {
    if (part.isNotEmpty) {
      initials += part[0].toUpperCase();
    }
  }

  return initials;
}
  void _handleUpdateProfile(List<String>? fieldsToUpdate) async {
    final updatedName = _nameController.text;
    final updatedPhoneNumber = _phoneController.text;
    final updatedCity = _cityController.text;
    final updatedAddress = _addressController.text;
    final updatedPassword =
        _passwordController.text.isNotEmpty ? _passwordController.text : '';

    const apiUrl = 'https://elifesaver.online/donor/includes/update_donor.inc.php';

    try {
      final Map<String, String> updatedFields = {};

      // Compare with the original values to determine which fields have been updated
      if (fieldsToUpdate == null || fieldsToUpdate.contains('name')) {
        updatedFields['name'] = updatedName;
      }
      if (fieldsToUpdate == null || fieldsToUpdate.contains('phone')) {
        updatedFields['phone'] = updatedPhoneNumber;
      }
      if (fieldsToUpdate == null || fieldsToUpdate.contains('city')) {
        updatedFields['city'] = updatedCity;
      }
      if (fieldsToUpdate == null || fieldsToUpdate.contains('address')) {
        updatedFields['address'] = updatedAddress;
      }
      if (fieldsToUpdate == null ||
          (fieldsToUpdate.contains('password') && updatedPassword.isNotEmpty)) {
        updatedFields['password'] = updatedPassword;
      }

      if (updatedFields.isEmpty) {
        // No fields have been updated, show a message to the user.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Changes'),
              content: Text('No fields have been updated.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Send only the updated fields in the API call
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': widget.userId.toString(),
          ...updatedFields,
        },
      );

      final jsonData = json.decode(response.body);
        print(jsonData);
      if (jsonData == null) {
        // Handle null response from the server.
        print('Server returned null data');
        print(jsonData);
        return;
      }

      // Check if the API response indicates success (you may need to adjust this based on your API response structure)
      if (jsonData['success'] == true) {
        // Profile update was successful, show success message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Profile update successful.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Profile update failed, show failure message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed'),
              content: Text('Profile update failed. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call.
      print('Error: $e');
      // Show error message to the user.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while updating the profile. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _updateAllFields() {
    _handleUpdateProfile(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Use const for constant widgets
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.red,
              child: Center(
                child: Row(
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child:CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      getInitials(widget.userName),
                                      style: TextStyle(color: Colors.black, fontSize:24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(width: 56),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'BTS:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.btsNumber,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: widget.userName,
                      ),
                      controller: _nameController,
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: widget.phoneNumber,
                      ),
                      controller: _phoneController,
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 55,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      widget.email,
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'City',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: widget.city,
                      ),
                      controller: _cityController,
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: widget.address,
                      ),
                      controller: _addressController,
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: 'Enter new password',
                      ),
                      controller: _passwordController,
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 360,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      color: Colors.red,
                    ),
                    child: TextButton(
                      onPressed: _updateAllFields,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}