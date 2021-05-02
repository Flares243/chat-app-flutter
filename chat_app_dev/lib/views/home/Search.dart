import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:chat_app_dev/widgets/Userinfor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class SearchSreen extends StatefulWidget {
   AppUser user;
   SearchSreen({ this.user });

   @override
   _SearchSreenState createState() => _SearchSreenState();
}

class _SearchSreenState extends State<SearchSreen> {
   final searchFormKey = GlobalKey<FormState>();
   TextEditingController _searchController = new TextEditingController();
   CollectionReference _usersCollection = FirebaseFirestore.instance.collection("users");

   List<AppUser> _searchedUsers;
   List<String> _addedUsers = [];
   bool _isSearching = false;

   _searchUser() async {
      setState(() {
        _isSearching = true;
      });

      List<AppUser> _result = [];

      await _usersCollection
         .where("usernameSearch", isEqualTo: _searchController.text.trim().toLowerCase())
         .orderBy("createAt").get()
         .then((snapshot) {
            snapshot.docs.forEach(
               (doc) {
                  _result.add(AppUser.queryDocSnapshotToAppUser(doc));
               }
            );
         });

         _result.removeWhere((element) => element.strUserId == widget.user.strUserId);

      setState(() {
         _isSearching = false;
         _searchedUsers = _result;
      });
   }

   _sendChatRequest(BuildContext context, AppUser _requestedUser) async {
      if (_addedUsers.contains(_requestedUser.strUserId)) {
         showFlash(
            context: context,
            duration: Duration(seconds: 3),
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
                        "Chat request already sended! Please wait for other user accept.",
                        style: TextStyle(color: Colors.white)
                     ),
                  )
               );
            }
         );
         return;
      }

      try {
         await FirestoreServices(uid: widget.user.strUserId).addChatRequest(_requestedUser, "sender");
         await FirestoreServices(uid: _requestedUser.strUserId).addChatRequest(widget.user, "receiver");
         setState(() {
            _addedUsers.add(_requestedUser.strUserId);
         });
      }
      catch(err) {
         throw err;
      }
   }

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            leading: IconButton(
               icon: Icon(
                  Icons.chevron_left,
                  size: 35,   
               ),
               onPressed: () {
                  Navigator.of(context).pop();
               },
            ),
            title: Form(
               key: searchFormKey,
               child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                     isDense: true,
                     hintText: "Search user name...",
                     hintStyle: TextStyle(color: Colors.grey),
                     border: InputBorder.none,
                     contentPadding: EdgeInsets.all(2),
                     focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                     ),
                  ),
                  style: TextStyle(
                     fontSize: 17,
                     color: Colors.white
                  ),
               ),
            ),
            actions: [
               IconButton(
                  onPressed: _searchUser,
                  icon: Icon(Icons.search)
               )
            ],
         ),
         body: _isSearching == true
         ? Center(child: CircularProgressIndicator())
         : _searchedUsers == null 
         ? SizedBox()
         : ListView.builder(
            itemCount: _searchedUsers.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
               return Card(
                  child: ListTile(
                     title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                              _searchedUsers[index].strName,
                              overflow: TextOverflow.ellipsis,
                           ),
                           Text(
                              _searchedUsers[index].strEmail,
                              style: TextStyle(
                                 color: Colors.grey.shade500,
                                 fontSize: 14
                              ),
                              overflow: TextOverflow.ellipsis,
                           )
                        ],
                     ),
                     leading: Icon(
                        Icons.person,
                        color: null
                     ),
                     onTap: () {
                        showFlash(
                           context: context,
                           persistent: false,
                           builder: (context, _controller) {
                              return Flash.dialog(
                                 controller: _controller,
                                 margin: EdgeInsets.symmetric(horizontal: 20),
                                 borderRadius: BorderRadius.all(Radius.circular(8)),
                                 child: FlashBar(
                                    message: UserInfor(user: widget.user,),
                                    actions: [
                                       TextButton(
                                          onPressed: () {
                                             _controller.dismiss();
                                          },
                                          child: Text("Close")
                                       )
                                    ],
                                 )
                              );
                           }
                        );
                     },
                     trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                           _sendChatRequest(context, _searchedUsers[index]);
                        },
                     ),
                  )
               );
            },
         ),
      );
   }
}