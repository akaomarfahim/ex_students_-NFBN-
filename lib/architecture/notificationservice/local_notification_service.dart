import 'dart:developer';
import '../file/download_and_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  // static String? route;
  // static const sound = 'long_pop';

  static Future _notificationDetails(String? url) async {
    log('URL:: $url');
    StyleInformation? styleInformation;
    AndroidBitmap<Object>? largeIcon;
    if (url != null) {
      final largeIconPath = await Utils.downloadFile(url, 'NFBN_All');
      styleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(largeIconPath), largeIcon: FilePathAndroidBitmap(largeIconPath), hideExpandedLargeIcon: false);
      largeIcon = FilePathAndroidBitmap(largeIconPath);
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'NFBN_All',
        'NFBN_All', // if changes you need to change that from androidManifest meta-data
        importance: Importance.max,
        priority: Priority.high,
        // sound: const RawResourceAndroidNotificationSound(sound),
        styleInformation: styleInformation,
        largeIcon: largeIcon,
        playSound: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        fullScreenIntent: true,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static Future showNotification(RemoteMessage? message) async {
    if (message != null) {
      log('notification called');
      // route = message.data['route'];
      log('ROUTE: ${message.data['route']}');
      try {
        final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await _notificationsPlugin.show(
          id,
          // message.notification!.title,
          // message.notification!.body,
          // ---- doing this like the way, because reciving this way so that firebase doesn't need to generate any automatic notifications.
          // peace :
          message.data['title'] ?? '',
          message.data['body'] ?? '',
          await _notificationDetails(message.data['imageUrl']),
          payload: message.data['route'],
        );
      } on Exception catch (e) {
        log("Error! Notification:  $e");
      }
    }
  }

  static Future initialize() async {
    // initializationSettings  for Android
    // const notificationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: IOSInitializationSettings());

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: initializationSettingsIOS);
    log('INITIALIZED CALLED');

    await _notificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (payload) {
      //   onNotification.add(payload);

      //   // log("INSIDE PAY");
      //   // log('PAY PAY:: $payload');

      //   if (payload != null) Navigator.of(context).pushNamed(MyRoutes.routine);
      // },
    );

    // _notificationsPlugin.initialize(
    //   notificationSettings,
    //   onSelectNotification: (payload) async {
    //     // log("onSelectNotification");
    //     // if (id!.isNotEmpty) {
    //     //   log("Router Value ::  $id");

    //     //   // Navigator.of(context).push(
    //     //   //   MaterialPageRoute(
    //     //   //     builder: (context) => DemoScreen(
    //     //   //       id: id,
    //     //   //     ),
    //     //   //   ),
    //     //   // );
    //     // }
    //   },
    // );
  }
}
