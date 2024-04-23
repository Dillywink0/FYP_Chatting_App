import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountSection("Avatar", _buildAvatarSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection("Email", _buildEmailSection(context)),
              const SizedBox(height: 16.0),
              _buildAccountSection(
                  "Discriminator", _buildDiscriminatorSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection("Phone Number", _buildPhoneNumberSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection("Password", _buildPasswordSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(String title, Widget sectionWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: sectionWidget,
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return const CircleAvatar(
      radius: 50.0,
      backgroundImage: AssetImage('assets/placeholder_avatar.png'),
    );
  }

  Widget _buildEmailSection(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc().snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Placeholder while loading
        }
        var email = snapshot
            .data!['email']; // Assuming 'email' is the field name in Firestore
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              email,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _handleChangeEmail(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Change",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDiscriminatorSection() {
    return const Text(
      "#1234",
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "+1 123-456-7890",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle button click to change phone number
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            "Change",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleChangePassword(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        "Change Password",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleChangeEmail(BuildContext context) {
    // Implement your logic to change email here
    // For now, let's just print a message
    print("Changing email...");
  }

  void _handleChangePassword(BuildContext context) {
    // Implement your logic to change password here
    // For now, let's just print a message
    print("Changing password...");
  }
}
