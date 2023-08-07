import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'notification.dart';

class DoctorScanPage extends StatefulWidget {
  @override
  _DoctorScanPageState createState() => _DoctorScanPageState();
}

class _DoctorScanPageState extends State<DoctorScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/edrick.jpg'),
          ),
          SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.dashboard, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Dashboard'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.notifications, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Notification'),
                ],
              ),
              onTap: () {
                
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.feedback, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Feedback'),
                ],
              ),
              onTap: () {
                // Handle feedback onTap
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.red,
              ),
              child: TextButton(
                onPressed: () {
                  if (controller != null) {
                    controller?.toggleFlash();
                    controller?.pauseCamera();
                    _showSendNotificationDialog();
                  }
                },
                child: Text(
                  'SCAN TO SEND NOTIFICATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Scanned QR Code Data: ${result?.code ?? 'No Data'}'),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    }, onError: (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    });
  }

  void _showSendNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Notification'),
          content: Text(result?.code ?? ''),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (controller != null) {
                  controller?.resumeCamera();
                  controller?.toggleFlash();
                  Navigator.of(context).pop();
                }
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Implement sending notification logic here
                // For example, send the notification to the donor based on the scanned data (result?.code)
                // sendNotificationToDonor(result?.code);
              },
              child: Text('SEND'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
