import 'package:chat_app_dev/views/authenticate/Signin.dart';
import 'package:chat_app_dev/views/authenticate/Signup.dart';
import 'package:flutter/material.dart';

class AuthenticateWrapper extends StatefulWidget {
   @override
   _AuthenticateWrapperState createState() => _AuthenticateWrapperState();
}

class _AuthenticateWrapperState extends State<AuthenticateWrapper> {
   bool _showSignIn = true;

   ToggleView() {
      setState(() {
        _showSignIn = !_showSignIn;
      });
   }

   @override
   Widget build(BuildContext context) {
      if (_showSignIn) {
         return SignIn(toggleView: ToggleView,);
      }
      else {
         return SignUp(toggleView: ToggleView,);
      }
   }
}