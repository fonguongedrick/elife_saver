import 'package:flutter/material.dart';

class Dashboardd extends StatelessWidget {
  final String? userName;

  const Dashboardd({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, ${userName ?? "Unknown user"}!'),
      ),
    );
  }
}