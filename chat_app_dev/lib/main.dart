import 'package:chat_app_dev/views/App.dart';
import 'package:chat_app_dev/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   runApp(InitApp());
}

class InitApp extends StatelessWidget {
   final Future<FirebaseApp> _initialization = Firebase.initializeApp();

   @override
   Widget build(BuildContext context) {
      return FutureBuilder(
         future: _initialization,
         builder: (context, snapshot) {
            if (snapshot.hasError) {
               return MaterialApp(
                  home: Center(
                     child: Container(
                        color: Colors.white,
                        child: Center(
                           child: Text("Something went wrong! Please check your connection and try again."),
                        ),
                     ),
                  ),
               );
            }

            if (snapshot.connectionState == ConnectionState.done) {
               return MyApp();
            }

            return MaterialApp(
               debugShowCheckedModeBanner: false,
               home: LoadingScreen()
            );
         },
      );
   }
}