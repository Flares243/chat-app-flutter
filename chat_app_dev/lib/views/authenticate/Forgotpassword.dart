import 'package:chat_app_dev/firebaseServices/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:chat_app_dev/widgets/commonWidgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
   AuthServices auth = new AuthServices();
   
   TextEditingController _emailControler = new TextEditingController();
   final formForgotPasswordKey = GlobalKey<FormState>();

   bool _isLoading = false;
   String _message;

   _sendEmail(BuildContext context) async {
      if (formForgotPasswordKey.currentState.validate()) {
         try {
            setState(() {
               _isLoading = true;
            });
            await auth.forgotPassword(_emailControler.text);
            _message = "Sended! Check your email for further instruction.";
         }
         catch(error) {
            _message = "Account doesn't exists! Please try again.";
         }
         finally {
            setState(() {
               _isLoading = false;
            });
            showFlash(
               context: context,
               duration: Duration(seconds: 4),
               builder: (context, _sendController) {
                  return Flash.bar(
                     position: FlashPosition.bottom,
                     horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
                     margin: EdgeInsets.all(8),
                     borderRadius: BorderRadius.all(Radius.circular(8)),
                     controller: _sendController,
                     backgroundColor: Theme.of(context).primaryColor,
                     child: FlashBar(
                        message: Text(
                           _message,
                           style: TextStyle(color: Colors.white)
                        ),
                     )
                  );
               }
            );
         }
      }
   }

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            title: Text("Reset Password"),
         ),
         body:_isLoading
         ? Container(
            color: Colors.white,
            child: Center(
               child: CircularProgressIndicator(),
            ),
         )
         : Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
               key: formForgotPasswordKey,
               child: Column(
                  children: [
                     SizedBox(height: 30),
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
                     GestureDetector(
                        onTap: () {_sendEmail(context);},
                        child: customMainButtonContainer(
                           context,
                           Color.fromARGB(255, 0, 160, 255),
                           Colors.white,
                           "Reset password"
                        ),
                     ),
                     SizedBox(height: 30),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
               ),
            ),
         ),
      );
   }
}