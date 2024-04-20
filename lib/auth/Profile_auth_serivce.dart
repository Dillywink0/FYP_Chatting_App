import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Add this line

  Future<String> updateProfilePicture(File image) async {
    try {
      User? user = _auth.currentUser;

      String filePath = 'profile_images/${user?.uid}.jpg';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(image);
      String fileName = 'profile_images/${user?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await uploadTask.whenComplete(() {});

      await _storage.ref(fileName).putFile(image);

      String downloadURL = await _storage.ref(filePath).getDownloadURL();

      await user?.updatePhotoURL(downloadURL);
      return downloadURL;
    } catch (error) {
      throw error;
    }
  }

  Future<Map<String, dynamic>> getUserDetailsByUid(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  Future<void> updateUserDetails(String userName, String email) async {
    try {
      User? user = _auth.currentUser;

      await user?.updateDisplayName(userName);
      await user?.updateEmail(email);
    } catch (error) {
      throw error;
    }
  }
}
