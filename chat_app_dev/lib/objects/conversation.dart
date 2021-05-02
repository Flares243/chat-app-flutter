import 'package:chat_app_dev/objects/message.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
   final String strCid;
   final DateTime dtCreateAt;
   final bool isGroup;
   final List<Message> lstMessage;
   final List<AppUser> lstUser;

   Conversation({
      this.strCid,
      this.dtCreateAt,
      this.isGroup,
      this.lstMessage,
      this.lstUser
   });

   static Conversation docSnapshotToConversation(DocumentSnapshot snapshot) {
      return new Conversation(
         strCid: snapshot.get("cid"),
         dtCreateAt: snapshot.get("createAt").toDate(),
         isGroup: snapshot.get("isGroup"),
         lstMessage: snapshot.get("messages")
            .map((message) {
               return Message.firestoreMapToMessage(message);
            }).toList().cast<Message>(),
         lstUser: snapshot.get("users")
            .map((uid) {
               return AppUser.firestoreStringToAppUser(uid);
            }).toList().cast<AppUser>()
      );
   }
}