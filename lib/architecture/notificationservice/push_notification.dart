import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<bool> callOnFcmApiSendPushNotifications({
  required String title,
  required String body,
  String topic = '',
  String? imageUrl,
  String? route,
}) async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "to": "/topics/$topic",
    // "type": "post_like",
    // "notification": {"title": '', "body": ''},
    // "token": "key=AAAAFqbZjI0:APA91bHZUAFpgJNJ77r7l1U79EVn5gSThQAPPjBhvPAN3k0HD_UJ4-mTQ3-eJ-vEynqPtfr86vFF4duA5uYdbU2Xfq4XGw00EUNQhB7Pg5YQXMWdXIKqn8NfBtwZPRT6RP7Bdf2g-5MQ",
    // ------------Important:
    /// sending this as a data not as a 'Notification':
    /// because sending it as a notification firebase generate a automatic notification and send it to the user.
    /// which shows only title and description.
    "priority": "high",
    "data": {"title": title, "body": body, "imageUrl": imageUrl, "route": route},
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAA2MgECn0:APA91bGSCtqCIG5hPd_UjDOnjprK1NXgJTJ4Ejdv4h_iDHq6SppSnw2hf8ibXK9yn6c2S8Tgc4uX_z7hc2M5l8dDpcP7nZED9_QKvSmFxLnpvH_NsW0baq_8zgyUIUqCvYTr76cRvZC4' // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    log('test ok push CFM');
    return true;
  } else {
    log(' CFM error');
    // on failure do sth
    return false;
  }
}
