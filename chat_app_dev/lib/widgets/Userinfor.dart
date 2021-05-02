import 'package:chat_app_dev/objects/user.dart';
import 'package:flutter/material.dart';

class UserInfor extends StatelessWidget {
   AppUser user;
   UserInfor({ this.user });

   @override
   Widget build(BuildContext context) {
      return Container(
         child: Center(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(
                     user.strName,
                     style: TextStyle(
                        fontSize: 30,
                     ),
                  ),
                  SizedBox(height: 15,),
                  Text("Email: " + user.strEmail),
               ],
            )
         ),
      );
   }
}