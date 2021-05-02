import 'package:chat_app_dev/firebaseServices/auth.dart';
import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:chat_app_dev/widgets/commonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/Authenticatewarpper.dart';
import 'home/Dashboard.dart';

class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
      return mainCustomMaterialApp(
         "Chat App",
         StreamBuilder<User>(
            stream: AuthServices().userStateChanged,
            builder: (context, snapshot) {
               if (snapshot.data == null) {
                  return AuthenticateWrapper();
               }

               return StreamProvider<AppUser>.value(
                  initialData: null,
                  value: FirestoreServices(uid: snapshot.data.uid).userDataChanged,
                  child: Dashboard()
               );
            }
         )
      );
   }
}