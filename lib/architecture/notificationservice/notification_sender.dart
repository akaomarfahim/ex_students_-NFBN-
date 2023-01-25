import 'package:base/architecture/notificationservice/push_notification.dart';

Future<void> sendNotification({required String title, required String description, String? imageUrl, required String recipient, String? route}) async {
  // int key = NoticeData.allNotice.length;
  // String subscribber = selectedRecipient.toString();
  await callOnFcmApiSendPushNotifications(
    title: title,
    body: description,
    topic: recipient,
    imageUrl: imageUrl,
    route: route,
  );
}
