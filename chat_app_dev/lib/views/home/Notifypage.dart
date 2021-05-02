import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/notifications.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
   final AppUser user;
   NotifyPage({ this.user });

   @override
   _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
   final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

   _acceptRequest(Notifications notify) async {
      try {
         final _requestUser = AppUser.docSnapshotToAppUser(await _usersCollection.doc(notify.strUserId).get());
         await FirestoreServices(uid: notify.strUserId).removeChatRequest(widget.user.mapChatRequest.map((key, value) => MapEntry<String, Map>(key, Notifications.toJSON(value))));
         await FirestoreServices(uid: widget.user.strUserId).removeChatRequest(_requestUser.mapChatRequest.map((key, value) => MapEntry<String, Map>(key, Notifications.toJSON(value))));
         await FirestoreServices(uid: widget.user.strUserId).createConversation(notify);
      }
      catch (err) {
         throw err;
      }
   }

   _cancelRequest(Notifications notify) async {
      try {
         var _requestUser = AppUser.docSnapshotToAppUser(await _usersCollection.doc(notify.strUserId).get());
         await FirestoreServices(uid: notify.strUserId).removeChatRequest(widget.user.mapChatRequest.map((key, value) => MapEntry<String, Map>(key, Notifications.toJSON(value))));
         await FirestoreServices(uid: widget.user.strUserId).removeChatRequest(_requestUser.mapChatRequest.map((key, value) => MapEntry<String, Map>(key, Notifications.toJSON(value))));
      }
      catch(err) {
         throw err;
      }
   }

   @override
   Widget build(BuildContext context) {
      var lstNotify = widget.user.mapChatRequest.values.toList();

      return Scaffold(
         appBar: AppBar(
            title: Text(
               "Notifications",
               style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
               ),
            ),
            centerTitle: true,
         ),
         body: ListView.builder(
            itemCount: lstNotify.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
               return ListTile(
                  leading: Icon(
                     Icons.person
                  ),
                  title: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Text(
                                 lstNotify[index].strName,
                                 overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                 lstNotify[index].strEmail,
                                 style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14
                                 ),
                                 overflow: TextOverflow.ellipsis,
                              )
                           ],
                        ),
                        lstNotify[index].strType == "receiver"
                        ? Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                              IconButton(
                                 onPressed: () async {
                                    await _acceptRequest(lstNotify[index]);
                                    setState(() {
                                       lstNotify.remove(lstNotify[index]);
                                    });
                                 },
                                 icon: Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                 ),
                              ),
                              IconButton(
                                 onPressed: () async {
                                    await _cancelRequest(lstNotify[index]);
                                    setState(() {
                                       lstNotify.remove(lstNotify[index]);
                                    });
                                 },
                                 icon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                 ),
                              )
                           ],
                        )
                        : Text(
                           "Waiting...",
                           style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14
                           ),
                           overflow: TextOverflow.ellipsis,
                        )
                     ]
                  )
               );
            },
         )
      );
   }
}