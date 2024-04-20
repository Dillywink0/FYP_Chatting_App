import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class Auth{
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

 User? get currentuser => _firebaseAuth.currentUser;

Stream<User?> get AuthStateChanges => _firebaseAuth.authStateChanges(); 

Future<void> signInwithEmailandPassword({
  required String email,
  required String password,
  
}) async{
  await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> signOut() async{
  await _firebaseAuth.signOut();
}
}