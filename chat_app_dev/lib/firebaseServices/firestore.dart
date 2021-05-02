import 'package:chat_app_dev/objects/conversation.dart';
import 'package:chat_app_dev/objects/message.dart';
import 'package:chat_app_dev/objects/notifications.dart';
import 'package:chat_app_dev/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
   final uid;
   final cid;
   FirestoreServices({ this.uid, this.cid });

   final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
   final CollectionReference _conversationsCollection = FirebaseFirestore.instance.collection('conversations');

   Stream<AppUser> get userDataChanged {
      return _usersCollection.doc(uid).snapshots()
         .map((snapshot) { return AppUser.docSnapshotToAppUser(snapshot); });
   }

   Stream<Conversation> get conversationDataChanged {
      return _conversationsCollection.doc(cid).snapshots()
         .map((snapshot) { return Conversation.docSnapshotToConversation(snapshot); });
   }

   Future createUserData(String username, String email) async {
      return await _usersCollection.doc(uid).set({
         'uid': uid,
         'username': username,
         'usernameSearch': username.toLowerCase(),
         'email': email,
         'conversation': {},
         'chatRequest': {},
         'createAt': FieldValue.serverTimestamp(),
      });
   }

   Future updateUserData(String username, String email) async {
      return await _usersCollection.doc(uid).update({
         'username': username,
         'usernameSearch': username.toLowerCase(),
      });
   }

   Future createConversation(Notifications notify) async {
      final convDoc = (await _conversationsCollection.add({})).id;

      final currUser = await _usersCollection.doc(uid).get();
      final otherUser = await _usersCollection.doc(notify.strUserId).get();
      Map mapCurr = currUser.get('conversation');
      Map mapOther = otherUser.get('conversation');

      mapCurr[convDoc] = notify.strUserId;
      mapOther[convDoc] = uid;

      await _usersCollection.doc(uid).update({
         'conversation': mapCurr
      });

      await _usersCollection.doc(notify.strUserId).update({
         'conversation': mapOther
      });
      
      return await _conversationsCollection.doc(convDoc).set({
         'cid': convDoc,
         'createAt': FieldValue.serverTimestamp(),
         'isGroup': false,
         'messages': [],
         'users': [uid, notify.strUserId]
      });
   }

   Future removeChatRequest(Map map) async {
      map.remove(uid);

      return await _usersCollection.doc(uid).update({
         'chatRequest': map
      });
   }

   Future addChatRequest(AppUser _requestedUser, String type) async {
      final _user = AppUser.docSnapshotToAppUser(await _usersCollection.doc(uid).get());
      final _requestList = _user.mapChatRequest.map((key, value) => MapEntry<String, Map>(key, Notifications.toJSON(value)));
      
      _requestList.addAll({
         _requestedUser.strUserId: {
            'email': _requestedUser.strEmail,
            'type': type,
            'uid': _requestedUser.strUserId,
            'username': _requestedUser.strEmail
         }
      });

      return await _usersCollection.doc(uid).update({
         'chatRequest': _requestList
      });
   }

   Future addMessage(Message message) async {
      return await _conversationsCollection.doc(cid).update({
         'messages': FieldValue.arrayUnion([Message.toJSON(message)])
      });
   }
}