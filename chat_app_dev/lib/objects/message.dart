class Message {
   final String strContent;
   final String strUid;
   final DateTime dtCreateAt;

   Message({
      this.dtCreateAt,
      this.strContent,
      this.strUid
   });

   static Message firestoreMapToMessage(Map message) {
      return Message(
         dtCreateAt: message["createAt"].toDate(),
         strContent: message["content"].trim(),
         strUid: message["uid"].trim(),
      );
   }

   static Map toJSON(Message message) {
      return {
         'content': message.strContent,
         'createAt': message.dtCreateAt,
         'uid': message.strUid
      };
   }
}