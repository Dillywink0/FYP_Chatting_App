import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Pages/friends_messaging/chatscreen.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<String> friendRequests = [];
  List<String> acceptedFriends = [];

  @override
  void initState() {
    super.initState();
    // Load friend requests and accepted friends when the page initializes.
    loadFriendRequests();
    loadAcceptedFriends();
  }

  // Load friend requests from Firestore.
  Future<void> loadFriendRequests() async {
    try {
      print('Loading friend requests...');
      List<String> requests = await getFriendRequests();
      // Update friendRequests and trigger a rebuild of the UI.
      setState(() {
        friendRequests = requests;
      });
      print('Friend requests loaded successfully.');
    } catch (e) {
      print('Error loading friend requests: $e');
      // Print additional information for debugging.
      print('Current user ID: ${FirebaseAuth.instance.currentUser!.uid}');
    }
  }

  // Load accepted friends from Firestore.
  Future<void> loadAcceptedFriends() async {
    try {
      print('Loading accepted friends...');
      List<String> friends = await getAcceptedFriends();
      // Update acceptedFriends and trigger a rebuild of the UI.
      setState(() {
        acceptedFriends = friends;
      });
      print('Accepted friends loaded successfully.');
    } catch (e) {
      print('Error loading accepted friends: $e');
      // Print additional information for debugging.
      print('Current user ID: ${FirebaseAuth.instance.currentUser!.uid}');
    }
  }

  Future<List<String>> getFriendRequests() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      List<String> requests =
          querySnapshot.docs.map((doc) => doc['senderId'].toString()).toList();
      return requests;
    } catch (e) {
      print('Error fetching friend requests: $e');
      return [];
    }
  }

  Future<List<String>> getAcceptedFriends() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('friends')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<String> friends =
          querySnapshot.docs.map((doc) => doc['friendId'].toString()).toList();
      return friends;
    } catch (e) {
      print('Error fetching accepted friends: $e');
      return [];
    }
  }

  Future<String> getUserFullName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        // Explicitly cast to Map<String, dynamic>
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        // Check if the 'fullname' field exists in the document data
        if (userData != null && userData.containsKey('fullName')) {
          String fullName = userData['fullName'].toString();
          return fullName;
        } else {
          // Handle the case where 'fullname' is missing
          print(
              'Error: Field "fullname" does not exist in the document for user $userId');
          return 'User';
        }
      } else {
        // Handle the case where the document doesn't exist
        print('Error: Document does not exist for user $userId');
        return 'User';
      }
    } catch (e) {
      print('Error fetching user information: $e');
      return 'User';
    }
  }

  void acceptFriendRequest(String friendRequestId) async {
    try {
      print('Accepting friend request from $friendRequestId');

      // Query the friend_requests collection to find the relevant document.
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('senderId', isEqualTo: friendRequestId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Check if the friend request has already been accepted.
        var friendRequestDoc = querySnapshot.docs.first;
        if (friendRequestDoc['status'] != 'accepted') {
          // Update the status of the document to 'accepted'.
          await friendRequestDoc.reference.update({'status': 'accepted'});

          // Add a new document to the 'friends' collection to represent the friendship.
          await FirebaseFirestore.instance.collection('friends').add({
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'friendId': friendRequestId,
          });

          // Remove the friend request from the UI by updating the state.
          setState(() {
            friendRequests.remove(friendRequestId);
            acceptedFriends.add(friendRequestId);
          });

          print('Friend request from $friendRequestId accepted successfully.');
        } else {
          print('Friend request from $friendRequestId already accepted.');
        }
      } else {
        print('Error accepting friend request: Document not found');
        // Handle the case where the friend request document is not found.
      }
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  void declineFriendRequest(String friendRequestId) async {
    try {
      print('Declining friend request from $friendRequestId');

      // Query the friend_requests collection to find the relevant document.
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('senderId', isEqualTo: friendRequestId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the status of the document to 'declined'.
        var friendRequestDoc = querySnapshot.docs.first;
        await friendRequestDoc.reference.update({'status': 'declined'});

        // Remove the friend request from the UI by updating the state.
        setState(() {
          friendRequests.remove(friendRequestId);
        });

        print('Friend request from $friendRequestId declined successfully.');
      } else {
        print('Error declining friend request: Document not found');
        // Handle the case where the friend request document is not found.
      }
    } catch (e) {
      print('Error declining friend request: $e');
    }
  }

  Widget _buildAcceptedFriendsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Accepted Friends",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: acceptedFriends.length,
                itemBuilder: (context, index) {
                  String friendId = acceptedFriends[index];
                  return FutureBuilder(
                    future: getUserFullName(friendId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading friend: ${snapshot.error}');
                      } else {
                        String friendFullName = snapshot.data.toString();
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              friendFullName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.message),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(friendId),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFriendRequestsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Friend Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: friendRequests.length,
                itemBuilder: (context, index) {
                  String requestId = friendRequests[index];
                  return FutureBuilder(
                    future: getUserFullName(requestId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading friend request: ${snapshot.error}');
                      } else {
                        String requesterFullName = snapshot.data.toString();
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              requesterFullName,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text('Friend Request'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    print('Accept button pressed');
                                    acceptFriendRequest(requestId);
                                  },
                                  child: const Text('Accept'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    declineFriendRequest(requestId);
                                  },
                                  child: const Text('Decline'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
        backgroundColor: Colors.blue, // Change app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the accepted friends list only if there are friends.
            if (acceptedFriends.isNotEmpty)
              _buildAcceptedFriendsList(),
            const SizedBox(height: 16),
            // Display friend requests.
            if (friendRequests.isNotEmpty)
              _buildFriendRequestsList(),
          ],
        ),
      ),
    );
  }
}
