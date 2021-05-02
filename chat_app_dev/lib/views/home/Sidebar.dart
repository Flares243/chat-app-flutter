import 'package:chat_app_dev/firebaseServices/auth.dart';
import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:chat_app_dev/views/home/Notifypage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
   final userid;
   SideBar({ this.userid });

   @override
   _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
   @override
   Widget build(BuildContext context) {
      return Drawer(
         child: StreamBuilder<AppUser>(
            stream: FirestoreServices(uid: widget.userid).userDataChanged,
            builder: (context, AsyncSnapshot<AppUser> snapshot) {
               if (snapshot.hasData) {
                  bool _isNotified = snapshot.data.mapChatRequest.isEmpty;

                  return ListView(
                     children: [
                        UserAccountsDrawerHeader(
                           accountName: Text(snapshot.data.strName, style: TextStyle(fontSize: 30),),
                           accountEmail: Text(snapshot.data.strEmail),
                        ),
                        ListTile(
                           leading: Icon(Icons.person, color: Color.fromARGB(255, 0, 160, 255)),
                           title: Text("Account"),
                           onTap: () {},
                        ),
                        ListTile(
                           leading: Icon(
                              _isNotified == false
                              ? Icons.notification_important
                              : Icons.notifications,
                              color: Colors.yellow.shade700
                           ),
                           title: Text("Notifications"),
                           onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                 CupertinoPageRoute<void>(
                                    builder: (context) => NotifyPage(user: snapshot.data)
                                 )
                              );
                           },
                        ),
                        ListTile(
                           leading: Container(
                              padding: EdgeInsets.all(2),
                              height: 25,
                              width: 25,
                              child: Image.asset('assets/images/mini-drive.png',),
                           ),
                           title: Text("Mini Drive"),
                           onTap: () {},
                        ),
                        new Divider(),
                        ListTile(
                           leading: Icon(Icons.exit_to_app),
                           title: Text("Log out"),
                           onTap: AuthServices().signOut,
                        ),
                     ],
                  );
               }
               return Center(child: CircularProgressIndicator());
            }
         ),
      );
   }
}