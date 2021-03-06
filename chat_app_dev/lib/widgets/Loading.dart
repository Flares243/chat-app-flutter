import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
      return Container(
         color: Color.fromARGB(255, 52, 58, 64),
         child: Center(
            child: SpinKitFadingGrid(
               color: Colors.white,
               size: 70.0,
            )
         )
      );
   }
}