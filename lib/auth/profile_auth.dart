import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserEmail() async {
    try {
      User? user = _auth.currentUser;
      return user?.email;
    } catch (e) {
      print("Error getting user email: $e");
      return null;
    }
  }
  // ... other methods
}
