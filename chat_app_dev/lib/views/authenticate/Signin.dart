import 'package:chat_app_dev/firebaseServices/auth.dart';
import 'package:chat_app_dev/views/authenticate/Forgotpassword.dart';
import 'package:chat_app_dev/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_dev/widgets/commonWidgets.dart';

class SignIn extends StatefulWidget {
   final Function toggleView;

   SignIn({ this.toggleView });

   @override
   _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
   AuthServices _auth = new AuthServices();

   TextEditingController _emailControler = new TextEditingController();
   TextEditingController _passwordControler = new TextEditingController();
   final formSignInKey = GlobalKey<FormState>();
   bool _obscureText = true;
   
   String _error = "";
   bool _isLoading = false;

   _signIn() async {
      if (formSignInKey.currentState.validate()) {
         setState(() {
           _isLoading = true;
         });

         dynamic result = await _auth.signInWithEmailAndPassword(
            _emailControler.text,
            _passwordControler.text
         );
         
         if (result == null) {
            setState(() {
               _error = "Please check your information and try again!";
               _isLoading = false;
            });
         }
      }
   }

   _toForgotPass(BuildContext context) {
      Navigator.of(context).push(
         CupertinoPageRoute<void>(
            builder: (context) => ForgotPassword()
         )
      );
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
                        key: formSignInKey,
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
                                    obscureText: _obscureText,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                       isDense: true,
                                       hintText: "Password",
                                       border: InputBorder.none,
                                       contentPadding: EdgeInsets.all(2),
                                       focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromARGB(255, 0, 160, 255), width: 2),
                                       ),
                                       errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red, width: 2),
                                       ),
                                       focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red, width: 2),
                                       ),
                                       icon: Icon(Icons.lock),
                                       errorStyle: TextStyle(
                                          height: 0.6,
                                       ),
                                       suffixIcon: IconButton(
                                          icon: _obscureText
                                             ? Icon(Icons.visibility)
                                             : Icon(Icons.visibility_off_rounded),
                                          onPressed: () {
                                             setState(() {
                                               _obscureText = !_obscureText;
                                             }); 
                                          },
                                       )
                                    ),
                                    style: TextStyle(
                                       fontSize: 20,
                                    ),
                                 ),
                              ),
                              GestureDetector(
                                 onTap:  () => { _toForgotPass(context) },
                                 child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                       "Forgot Password?",
                                       style: TextStyle(
                                          decoration: TextDecoration.underline,
                                       ),
                                    ),
                                 ),
                              ),
                              Divider(),
                              GestureDetector(
                                 onTap: _signIn,
                                 child: customMainButtonContainer(
                                    context,
                                    Color.fromARGB(255, 0, 160, 255),
                                    Colors.white,
                                    "Sign in"
                                 ),
                              ),
                              Container(
                                 margin: EdgeInsets.only(top: 10),
                                 child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(
                                          "Don't have an account? ",
                                          style: TextStyle( fontSize: 15, ),
                                       ),
                                       GestureDetector(
                                          onTap: widget.toggleView,
                                          child: Text(
                                             "Sign up",
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
                     ),
                  ),
               ),
            );
         }),
      );
   }
}