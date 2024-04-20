import 'package:flutter/material.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement your logic to display the list of devices here
    return Scaffold(
      appBar: AppBar(
        title: Text('Logged-in Devices'),
      ),
      body: Center(
        child: Text('List of logged-in devices goes here.'),
      ),
    );
  }
}