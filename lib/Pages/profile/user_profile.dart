import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
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
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(_user.uid).get();

    setState(() {
      _userData = userSnapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
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
                      _userData['profilePicture'] ??
                          'https://example.com/path/to/default/image.jpg',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userData['fullName'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _userData['email'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _handleAddStatus(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Text(
                  "Add Status",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _handleEditProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildAccountSection("Name", _buildUsernameSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection(
                  "Discriminator", _buildDiscriminatorSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection(
                  "Phone Number", _buildPhoneNumberSection()),
              const SizedBox(height: 16.0),
              _buildAccountSection("Email", _buildEmailSection(context)),
              const SizedBox(height: 16.0),
              _buildAccountSection(
                  "Password", _buildPasswordSection(context)),
              const SizedBox(height: 16.0),
              _buildAccountSection(
                  "Profile Picture", _buildProfilePictureSection(context)),
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

  Widget _buildUsernameSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _userData['fullName'] ?? 'N/A',
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _handleChangeName(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
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

  Widget _buildDiscriminatorSection() {
    return Text(
      _userData['discriminator'] ?? 'N/A',
      style: const TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _userData['phone'] ?? 'N/A',
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle button click to change phone number
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
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

  Widget _buildEmailSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _userData['email'] ?? 'N/A',
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _handleChangeEmail(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
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

  void _handleChangeEmail(BuildContext context) async {
    // Show a dialog to get the new email from the user
    String? newEmail = await _showChangeEmailDialog(context);

    if (newEmail != null && newEmail.isNotEmpty) {
      // Update the email in Firebase Authentication
      try {
        await _user.updateEmail(newEmail);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email updated successfully')),
        );

        // Update the email in Cloud Firestore
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .update({'email': newEmail});

        // Refresh user data
        await _fetchUserData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: $e')),
        );
      }
    }
  }

  Future<String?> _showChangeEmailDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'New Email'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(emailController.text);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _handleChangeName(BuildContext context) async {
    // Show a dialog to get the new name from the user
    String? newName = await _showChangeNameDialog(context);

    if (newName != null && newName.isNotEmpty) {
      // Update the name in Cloud Firestore
      await _firestore
          .collection('users')
          .doc(_user.uid)
          .update({'fullName': newName});

      // Refresh user data
      await _fetchUserData();
    }
  }

  Future<String?> _showChangeNameDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'New Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(nameController.text);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleChangePassword(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: const Text(
        "Change Password",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleChangePassword(BuildContext context) async {
    try {
      // Show a dialog to get the new password from the user
      String? newPassword = await _showChangePasswordDialog(context);

      if (newPassword != null && newPassword.isNotEmpty) {
        // Update the password in Firebase Authentication
        await _user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
    }
  }

  Future<String?> _showChangePasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(passwordController.text);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfilePictureSection(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _handleImageUpload(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: const Text(
        "Change Profile Picture",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _handleImageUpload(BuildContext context) async {
    // Implement image uploading logic here
    // Show a dialog or navigate to a new screen for image selection and uploading
    // Example: use image_picker package for image selection

    // Pseudo-code to guide you:
    // File? imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    //
    // if (imageFile != null) {
    //   String imageUrl = await _uploadImageToStorage(imageFile);
    //   await _updateProfilePictureInFirestore(imageUrl);
    //
    //   // Refresh user data
    //   await _fetchUserData();
    // }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    // Generate a unique filename for the image
    String fileName = '${_user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Reference to the Firebase Storage location
    Reference storageReference = _storage.ref().child('profile_pictures/$fileName');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Wait for the upload to complete
    await uploadTask.whenComplete(() => null);

    // Get the download URL of the uploaded file
    String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  Future<void> _updateProfilePictureInFirestore(String imageUrl) async {
    // Update the profile picture URL in Cloud Firestore
    await _firestore
        .collection('users')
        .doc(_user.uid)
        .update({'profilePicture': imageUrl});
  }

  void _handleEditProfile(BuildContext context) {
    // Add logic to handle edit profile button click
  }

  void _handleAddStatus(BuildContext context) {
    // Add logic to handle add status button click
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
