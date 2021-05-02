import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
   final FirebaseAuth _auth = FirebaseAuth.instance;

   AppUser _signedUser(User user) {
      return (user != null) ? AppUser(strUserId: user.uid, strEmail: user.email) : null; 
   }

   Stream<User> get userStateChanged {
      return _auth.authStateChanges();
   }

   Future signInWithEmailAndPassword(String email, String password) async {
      try {
         UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
         User _user = result.user;
         return _signedUser(_user);
      }
      catch(error) {
         print(error.toString());
         return null;
      }
   }

   Future signUpWithEmailAndPassword(String username, String email, String password) async {
      try {
         UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
         User user = result.user;
         await FirestoreServices(uid: user.uid).createUserData(username, email);
         return _signedUser(user);
      }
      catch(error) {
         print(error.toString());
         return null;
      }
   }

   Future forgotPassword(String email) async {
      await _auth.sendPasswordResetEmail(email: email);
   }

   Future signOut() async {
      try {
         return await _auth.signOut();
      }
      catch(error) {
         print(error.toString());
         return null;
      }
   }
}