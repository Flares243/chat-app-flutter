import 'package:chat_app_dev/firebaseServices/firestore.dart';
import 'package:chat_app_dev/objects/conversation.dart';
import 'package:chat_app_dev/objects/message.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:chat_app_dev/widgets/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
   String cid, roomName;
   AppUser currentUser;
   ChatRoom({ this.cid, this.roomName, this.currentUser});

   @override
   _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
   TextEditingController _messageController = new TextEditingController();

   void _sendMessage() async {
      try {
         Message message = new Message(
            strContent: _messageController.text,
            strUid: widget.currentUser.strUserId,
            dtCreateAt: new DateTime.now()
         );
         await FirestoreServices(cid: widget.cid).addMessage(message);
         _messageController.text = "";
      }
      catch(err) {
         throw err;
      }
   }

   @override
   Widget build(BuildContext context) {
      return mainCustomMaterialApp(
         "Chat Room",
         Scaffold(
            appBar: AppBar(
               title: Text(
                  widget.roomName,
                  style: TextStyle(
                     fontSize: 26,
                     color: Colors.white,
                  ),
               ),
               backgroundColor: Color.fromARGB(255, 52, 58, 64),
               centerTitle: true,
               elevation: 0.0,
               leading: IconButton(
                  icon: Icon(
                     Icons.chevron_left,
                     size: 35,   
                  ),
                  onPressed: () {
                     Navigator.of(context).pop();
                  },
               ),
            ),
            body: Column(
               children: [
                  Expanded(
                     child: Consumer<Conversation>(
                        builder: (context, _conversationInfor, child) { 
                           if (_conversationInfor != null) {
                              List<Message> _messages = _conversationInfor.lstMessage;

                              return ListView.builder(
                                 itemCount: _messages.length,
                                 padding: EdgeInsets.symmetric(vertical: 8),
                                 itemBuilder: (context, index) {
                                    bool _isCurrentUser = _messages[index].strUid == widget.currentUser.strUserId;

                                    return Container(
                                       constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                                       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                                       child: Align(
                                          alignment: _isCurrentUser
                                             ? Alignment.topRight
                                             : Alignment.topLeft,
                                          child: Container(
                                             decoration: _isCurrentUser
                                             ? BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                   topLeft: Radius.circular(16),
                                                   topRight: Radius.circular(16),
                                                   bottomLeft: Radius.circular(16)
                                                ),
                                                color: Color.fromARGB(255, 0, 140, 240),
                                             )
                                             : BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                   topLeft: Radius.circular(16),
                                                   topRight: Radius.circular(16),
                                                   bottomRight: Radius.circular(16)
                                                ),
                                                color: Colors.grey.shade400,
                                             ),
                                             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                             child: Text(
                                                _messages[index].strContent,
                                                style: TextStyle(
                                                   fontSize: 15,
                                                   color: _isCurrentUser
                                                      ? Colors.white
                                                      : Colors.black87
                                                ),
                                             ),
                                          )
                                       ),
                                    );
                                 }
                              );
                           }

                           return SizedBox();
                        }
                     ),
                  ),
                  Container(
                     padding: EdgeInsets.only(left: 20),
                     decoration: BoxDecoration(
                        boxShadow: [
                           BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 32,
                              color: Colors.grey.shade500
                           ),
                        ],
                        color: Theme.of(context).primaryColor,
                     ),
                     child: SafeArea(
                        child: Row(
                           children: [
                              Expanded(
                                 child: TextFormField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                       isDense: true,
                                       hintText: "Write message...",
                                       hintStyle: TextStyle(color: Colors.grey.shade300),
                                       border: InputBorder.none,
                                       contentPadding: EdgeInsets.all(2),
                                       focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                       ),
                                    ),
                                    style: TextStyle(
                                       fontSize: 17,
                                       color: Colors.white
                                    ),
                                 ),
                              ),
                              SizedBox(width: 10,),
                              FloatingActionButton(
                                 onPressed: () {
                                    _sendMessage();
                                 },
                                 child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 30,
                                 ),
                                 backgroundColor: Colors.transparent,
                                 elevation: 0.0,
                              ),                            
                           ],
                        ),
                     )
                  ),
               ],
            ),
         )
      );
   }
}