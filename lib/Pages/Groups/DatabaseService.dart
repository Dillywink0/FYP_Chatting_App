import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference friendRequestsCollection = FirebaseFirestore.instance.collection('friendRequests');

  // Get user details
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  // Get a list of user's friends
  Future<List<String>> getUserFriends(String userId) async {
    DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
    List<String> friends = List<String>.from(userDoc['friends'] ?? []);
    return friends;
  }

  // Send a friend request
 // Future<void> sendFriendRequest(String senderId, String receiverId) async {
 //   await friendRequestsCollection.doc(receiverId).collection('requests').doc(senderId).set({
  //    'senderId': senderId,
   //   'receiverId': receiverId,
   //   'timestamp': FieldValue.serverTimestamp(),
   // });
  }

  // Accept a friend request
  //Future<void> acceptFriendRequest(String senderId, String receiverId) async {
   // // Add sender to the receiver's friend list
  //  await usersCollection.doc(receiverId).update({
   //   'friends': FieldValue.arrayUnion([senderId]),
   // });

    // Add receiver to the sender's friend list
    //await usersCollection.doc(senderId).update({
    //  'friends': FieldValue.arrayUnion([receiverId]),
   // });

    // Delete the friend request
 //   await friendRequestsCollection.doc(receiverId).collection('requests').doc(senderId).delete();
 // }

  // Decline a friend request
 // Future<void> declineFriendRequest(String senderId, String receiverId) async {
    // Delete the friend request
  //  await friendRequestsCollection.doc(receiverId).collection('requests').doc(senderId).delete();
 // }

  // Get friend requests for a user
  //Stream<QuerySnapshot> getFriendRequests(String userId) {
 //   return friendRequestsCollection.doc(userId).collection('requests').snapshots();
  //}

  void sendMessage(String text) async {
  try {
    await FirebaseFirestore.instance
        .collection('your_messages_collection')
        .add({
          'senderId': FirebaseAuth.instance.currentUser!.uid,
          'text': text,
          'timestamp': DateTime.now(),
        });
  } catch (e) {
    print("Error sending message: $e");
  }
}

