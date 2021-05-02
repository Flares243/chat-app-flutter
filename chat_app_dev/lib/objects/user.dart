import 'package:chat_app_dev/objects/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
   final String strUserId;
   final String strName;
   final String strEmail;
   final DateTime dtCreateAt;
   final List<String> lstConversation;
   final Map<String, Notifications> mapChatRequest;
   
   AppUser({ 
      this.strUserId,
      this.strEmail,
      this.strName,
      this.dtCreateAt,
      this.lstConversation,
      this.mapChatRequest
   });

   static AppUser docSnapshotToAppUser(DocumentSnapshot snapshot) {
      return new AppUser(
         strEmail: snapshot.get("email").trim(),
         strName: snapshot.get("username").trim(),
         strUserId: snapshot.get("uid").trim(),
         dtCreateAt: snapshot.get("createAt").toDate(),
         lstConversation: snapshot.get("conversation").keys.toList().cast<String>(),
         mapChatRequest: Map<String, Notifications>.from(snapshot.get("chatRequest").map((key, value) {
            return MapEntry(key.trim(), Notifications.firebaseMapToNotifications(value));
         }))
      );
   }

   static AppUser queryDocSnapshotToAppUser(QueryDocumentSnapshot snapshot) {
      return new AppUser(
         strEmail: snapshot.get("email").trim(),
         strName: snapshot.get("username").trim(),
         strUserId: snapshot.get("uid").trim(),
         dtCreateAt: snapshot.get("createAt").toDate(),
         lstConversation: snapshot.get("conversation").keys.toList().cast<String>(),
         mapChatRequest: Map<String, Notifications>.from(snapshot.get("chatRequest").map((key, value) {
            return MapEntry(key.trim(), Notifications.firebaseMapToNotifications(value));
         }))
      );
   }

   static AppUser firestoreStringToAppUser(String uid) {
      return new AppUser(
         strUserId: uid.trim(),
      );
   }
}