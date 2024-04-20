import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // deals with the messsages
  Future<void> sendMessage(String recevierUserID, string ,message) async {

    final String currentUserId = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
return _firestore.collection("Users").snapshots().map((snapshot) {
  return snapshot.docs.map((doc) {
    final user = doc.data();
    return user;
  }).toList();
});
  }
  }