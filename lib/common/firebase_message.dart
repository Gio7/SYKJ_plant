import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:plant/common/global_data.dart';

class FirebaseMessage {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void init() async {
     /*NotificationSettings settings = */await  messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //  initForeground();
    //  print('token---${GlobalData.fcmToken}');
    // print('User granted permission: ${settings.authorizationStatus}');
  }

  /*void initForeground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }*/
}
