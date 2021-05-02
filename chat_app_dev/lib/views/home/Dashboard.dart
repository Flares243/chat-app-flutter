import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/conversation.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:chat_app_dev/views/home/Chatroom.dart';
import 'package:chat_app_dev/views/home/Search.dart';
import 'package:chat_app_dev/views/home/Sidebar.dart';
import 'package:chat_app_dev/widgets/Loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
   final CollectionReference _conversationCollection = FirebaseFirestore.instance.collection("conversations");
   final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

   @override
   Widget build(BuildContext context) {
      return Consumer<AppUser>(
         builder: (context, AppUser user, child) {
            if (user != null) {
               var _chatList = user.lstConversation;

               return Scaffold(
                  endDrawer: SideBar(userid: user.strUserId),
                  drawerEdgeDragWidth: 100,
                  appBar: AppBar(
                     leading: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset(
                           'assets/images/icons8-speech-bubble-64.png',
                        ),
                     ),
                     title: Text(
                        "Chat App",
                        style: TextStyle(
                           fontSize: 32,
                           color: Colors.white,
                        ),
                     ),
                     backgroundColor: Color.fromARGB(255, 52, 58, 64),
                     centerTitle: true,
                     elevation: 0.0,
                  ),
                  body: ListView(
                     padding: EdgeInsets.all(10),
                     children: _chatList.map<Widget>((cid) {
                        return FutureBuilder<DocumentSnapshot>(
                           future: _conversationCollection.doc(cid).get(),
                           builder: (context, AsyncSnapshot<DocumentSnapshot> conversationSnapshot) {
                              if (conversationSnapshot.hasData) {
                                 bool _isGroup = conversationSnapshot.data.get("isGroup");
                                 String _chatName;

                                 List _userList = conversationSnapshot.data.get("users");
                                 _userList.remove(user.strUserId);

                                 return FutureBuilder(
                                    future: _usersCollection.doc(_userList[0]).get(),
                                    builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                       if (userSnapshot.data != null) {
                                          AppUser _otherUser = AppUser.docSnapshotToAppUser(userSnapshot.data);

                                          if (_isGroup) {
                                             _chatName = conversationSnapshot.data.get("groupName");
                                          }
                                          else {
                                             _chatName = _otherUser.strName;
                                          }
                                          
                                          return UserTile(_chatName, _isGroup, _otherUser, context, cid, user);
                                       }

                                       return SizedBox();
                                    }
                                 );
                              };
                  
                              return SizedBox();
                           }
                        );
                     }).toList(),
                  ),
                  floatingActionButton: searchNavigator(context, user)
               );
            }

            return LoadingScreen();
         }
      );
   }

   Card UserTile(String _chatName, bool _isGroup, AppUser _otherUser, BuildContext context, String cid, AppUser user) {
      return Card(
         child: ListTile(
            leading: Icon(
               Icons.person
            ),
            title: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text(
                     _chatName,
                     overflow: TextOverflow.ellipsis,
                  ),
                  _isGroup
                  ? SizedBox()
                  : Text(
                     _otherUser.strEmail,
                     style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14
                     ),
                     overflow: TextOverflow.ellipsis,
                  )
               ],
            ),
            onTap: () {
               Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                     builder: (context) {
                        return StreamProvider<Conversation>.value(
                           initialData: null,
                           value: FirestoreServices(cid: cid).conversationDataChanged,
                           child: ChatRoom(cid: cid, roomName: _chatName, currentUser: user)
                        );
                     }
                  )
               );
            },
         ),
      );
   }

   FloatingActionButton searchNavigator(BuildContext context, AppUser user) {
      return FloatingActionButton(
         onPressed: () => {
            Navigator.of(context).push(
               CupertinoPageRoute<void>(
                  builder: (context) => SearchSreen(user: user)
               )
            )
         },
         tooltip: "Search",
         child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(
                  Icons.add,
                  size: 19,
               ),
               Icon(
                  Icons.person,
                  size: 25,
               )
            ],
         ),
      );
   }
}