class Notifications {
   final String strUserId;
   final String strName;
   final String strEmail;
   final String strType;

   Notifications({
      this.strEmail,
      this.strName,
      this.strType,
      this.strUserId
   });

   static Notifications firebaseMapToNotifications(Map map) {
      return new Notifications(
         strName: map["username"].trim(),
         strEmail: map["email"].trim(),
         strType: map["type"].trim(),
         strUserId: map["uid"].trim(),
      );
   }

   static Map toJSON(Notifications notify) {
      return {
         'email': notify.strEmail.trim(),
         'type': notify.strType.trim(),
         'uid': notify.strUserId.trim(),
         'username': notify.strName.trim()
      };
   }
}