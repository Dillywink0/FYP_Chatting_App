import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late User _user;
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(_user.uid).get();

    return userSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchUserData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            _userData = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add logic to view profile picture in full screen
                      },
                      child: Hero(
                        tag: 'profile_picture',
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            _userData['profilePicture'] ?? '',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _userData['fullName'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userData['email'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleAddStatus(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      ),
                      child: const Text(
                        "Add Status",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _handleEditProfile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _handleEditProfile(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    // Show a dialog with a form to edit the email address
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'New Email Address'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                String newEmail = emailController.text.trim();

                // Validate email format
                if (newEmail.isNotEmpty && newEmail.contains('@')) {
                  // Update email address in Firebase Authentication
                  await _user.updateEmail(newEmail);

                  // Update email address in Firestore
                  await _firestore
                      .collection('users')
                      .doc(_user.uid)
                      .update({'email': newEmail});

                  // Update UI
                  setState(() {
                    _userData['email'] = newEmail;
                  });

                  // Close dialog
                  Navigator.of(context).pop();
                } else {
                  // Show error message for invalid email format
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid email address')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _handleAddStatus(BuildContext context) {
    // Add logic to handle add status button click
  }

  // Other methods from the provided code...

  // You can add other methods from the provided code here as well.
}

void main() {
  runApp(const MaterialApp(
    home: ProfileScreen(),
  ));
}
