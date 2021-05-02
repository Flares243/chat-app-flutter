import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context, String title) {
   return AppBar(
      title: Text(
         title,
         style: TextStyle(
            fontSize: 30,
            color: Colors.white,
         ),
      ),
      leading: Container(
         margin: EdgeInsets.all(10),
         child: Image.asset(
            'assets/images/icons8-speech-bubble-64.png',
         ),
      ),
      backgroundColor: Color.fromARGB(255, 52, 58, 64),
      centerTitle: true,
      elevation: 0.0,
   );
}

Widget customMainTextInputContainer(Widget txt) {
   return Container(
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
         color: Colors.white,
         border: Border.all(color: Color.fromARGB(255, 196, 192, 198)),
         borderRadius: BorderRadius.all(new Radius.circular(10)),
      ),
      child: txt,
   );
}

InputDecoration customMainTextInputDecoration(String hint, IconData icon) {
   return InputDecoration(
      isDense: true,
      hintText: hint,
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
      icon: Icon(icon),
      errorStyle: TextStyle(
         height: 0.6,
      ),
   );
}

Widget customMainButtonContainer(BuildContext context, Color backgroundColor, Color textColor, String title) {
   return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 14),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
         color: backgroundColor,
         border: Border.all(color: Color.fromARGB(255, 200, 200, 200), width: 0.5),
         borderRadius: BorderRadius.circular(90),
      ),
      child: Text(
         title,
         style: TextStyle(color: textColor, fontSize: 20),
      ),
   );
}

MaterialApp mainCustomMaterialApp(String title, Widget widget) {
   return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         dividerTheme: DividerThemeData(
            space: 45,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(255, 200, 200, 200),
         ),
         scaffoldBackgroundColor: Color.fromARGB(255, 235, 235, 235),
         primaryColor: Color.fromARGB(255, 52, 58, 64),
      ),
      home: widget,
   );
}