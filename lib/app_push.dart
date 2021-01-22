import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_finder/utils.dart';

//notificatiopn handler
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();

// final BehaviorSubject<String> selectNotificationSubject =
//     BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});
}

class AppPushs extends StatefulWidget {
  AppPushs({
    @required this.child,
  });

  final Widget child;

  @override
  AppPushsState createState() => AppPushsState();
}

class AppPushsState extends State<AppPushs> {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String appToken;

  @override
  initState() {
    super.initState();
    _initLocalNotifications();
    _initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _initLocalNotifications() {
    // Android setting
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // IOS setting
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        // didReceiveLocalNotificationSubject.add(
        //   ReceivedNotification(
        //       id: id, title: title, body: body, payload: payload),
        // );
      },
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      // selectNotificationSubject.add(payload);
    });
  }

  _initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        // print('Message also contained a notification: ${message.notification}');
        _showNotification(
            message.notification.title, message.notification.body);
      }
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    messaging.getToken().then((value) async {
      print("FirebaseMessaging token: $value");
      appToken = value;
      await setStringValue('firebase_messaging_token', value);
    });

    // _firebaseMessaging.configure(
    //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //     onMessage: (Map<String, dynamic> message) async {
    //       print('onMessage: $message');
    //       final notification = message['notification'];
    //       _showNotification(notification['title'], notification['body']);
    //       return;
    //     },
    //     onLaunch: (Map<String, dynamic> message) async {
    //       print('onLaunch: $message');
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       print('onResume: $message');
    //     });
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<void> myBackgroundMessageHandler(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      _showNotification(message.notification.title, message.notification.body);
    }
    return Future<void>.value();
  }

  static Future _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'infixEdu', 'infix', 'this channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        0, '$title', '$body', platformChannelSpecifics,
        payload: 'infixEdu');
  }
}
