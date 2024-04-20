import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const UserDetailsScreen({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: $userId'),
            SizedBox(height: 8),
            Text('User Name: $userName'),
            // Add more user details as needed
          ],
        ),
      ),
    );
  }
}