import 'package:chat_app_dev/firebaseServices/auth.dart';
import 'package:chat_app_dev/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_dev/widgets/commonWidgets.dart';

class SignUp extends StatefulWidget {
   final Function toggleView;

   SignUp({ this.toggleView });

   @override
   _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   AuthServices _auth = new AuthServices();

   TextEditingController _usernameControler = new TextEditingController();
   TextEditingController _emailControler = new TextEditingController();
   TextEditingController _passwordControler = new TextEditingController();
   TextEditingController _confirmControler = new TextEditingController();
   final formSignUpKey = GlobalKey<FormState>();

   String _error = "";
   bool _isLoading = false;

   _signUp() async {
      if (formSignUpKey.currentState.validate()) {
         setState(() {
           _isLoading = true;
         });

         dynamic result = await _auth.signUpWithEmailAndPassword(
            _usernameControler.text,
            _emailControler.text,
            _passwordControler.text
         );

         if (result == null) {
            setState(() {
               _error = "Please check your connection and try again!";
               _isLoading = false;
            });
         }
      }
   }

   @override
   Widget build(BuildContext context) {
      return _isLoading
      ? LoadingScreen()
      : Scaffold(
         appBar: appBarMain(context, "Welcome"),
         body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
               padding: EdgeInsets.symmetric(horizontal: 20),
               child: ConstrainedBox(
                  constraints: BoxConstraints(
                     minWidth: constraints.maxWidth,
                     minHeight: constraints.maxHeight
                  ),
                  child: IntrinsicHeight(
                     child: Form(
                        key: formSignUpKey,
                        child: Column(
                           children: [
                              Text(
                                 _error,
                                 style: TextStyle(color: Colors.red, fontSize: 15, decoration: TextDecoration.underline)
                              ),
                              SizedBox(height: 20),
                              customMainTextInputContainer(
                                 TextFormField(
                                    validator: (value) {
                                       RegExp reg = RegExp(r"^(?=.{5,}$)[a-zA-Z0-9]");
                                       if (reg.hasMatch(value)) {
                                          return null;
                                       }
                                       return "Need to be atleast 5 characters long!";
                                    },
                                    controller: _usernameControler,
                                    decoration: customMainTextInputDecoration("Username", Icons.person),
                                    style: TextStyle(
                                       fontSize: 20,
                                    ),
                                 ),
                              ),
                              customMainTextInputContainer(
                                 TextFormField(
                                    validator: (value) {
                                       RegExp reg = RegExp(r"^[a-zA-Z0-9-_]+@([a-zA-Z0-9-_]+\.)+[a-zA-Z0-9]{2,5}$");
                                       if (reg.hasMatch(value)) {
                                          return null;
                                       }
                                       return "Please correct your email!";
                                    },
                                    controller: _emailControler,
                                    decoration: customMainTextInputDecoration("example@email.com", Icons.email),
                                    style: TextStyle(
                                       fontSize: 20,
                                    ),
                                 ),
                              ),
                              customMainTextInputContainer(
                                 TextFormField(
                                    validator: (value) {
                                       RegExp reg = RegExp(r"^(.*[a-zA-Z0-9]{3,})");
                                       if (reg.hasMatch(value)) {
                                          return null;
                                       }
                                       return "Need to be atleast 6 characters long!";
                                    },
                                    controller: _passwordControler,
                                    obscureText: true,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: customMainTextInputDecoration("Password", Icons.lock),
                                    style: TextStyle(
                                       fontSize: 20,
                                    ),
                                 ),
                              ),
                              customMainTextInputContainer(
                                 TextFormField(
                                    validator: (value) {
                                       if (value != _passwordControler.text) {
                                          return "Password does not matches!";
                                       }
      
                                       return null;
                                    },
                                    controller: _confirmControler,
                                    obscureText: true,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: customMainTextInputDecoration("Confirm password", Icons.lock),
                                    style: TextStyle(
                                       fontSize: 20,
                                    ),
                                 ),
                              ),
                              Divider(),
                              GestureDetector(
                                 onTap: _signUp,
                                 child: customMainButtonContainer(
                                    context,
                                    Color.fromARGB(255, 0, 160, 255),
                                    Colors.white,
                                    "Sign up"
                                 ),
                              ),
                              Container(
                                 margin: EdgeInsets.only(top: 10),
                                 child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(
                                          "Already have an account? ",
                                          style: TextStyle( fontSize: 15, ),
                                       ),
                                       GestureDetector(
                                          onTap: widget.toggleView,
                                          child: Text(
                                             "Sign in",
                                             style: TextStyle(
                                                fontSize: 15,
                                                decoration: TextDecoration.underline,
                                             ),
                                          ),
                                       ),
                                    ],
                                 ),
                              ),
                              SizedBox(height: 30),
                           ],
                           mainAxisAlignment: MainAxisAlignment.center,
                           mainAxisSize: MainAxisSize.max,
                        ),
                     )
                  ),
               ),
            );
         }),
      );
   }
}