import 'dart:developer';
import 'package:base/architecture/dialog/__loading_dialog.dart';

import '../../main.dart';
import '../root/root.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../backend/firebase_storage_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:base/architecture/dialog/__show_dialog.dart';
import 'package:base/architecture/widget_default/__toast.dart';
import 'package:base/architecture/notificationservice/notification_sender.dart';

class NavigationRoute {
  static var currentPage = MyRoutes.home;
}

route(BuildContext context, String route) async {
  NavigationRoute.currentPage = route;
  if (NavigationRoute.currentPage == MyRoutes.exit) {
    SystemNavigator.pop();
  } else if (NavigationRoute.currentPage == MyRoutes.feedback) {
    const url = 'mailto:${ROOT.feedBackMail}?subject=${ROOT.feedBackMailSubject}';
    NavigationRoute.currentPage = MyRoutes.home;
    launchUrl(Uri.parse(url));
  } else if (NavigationRoute.currentPage == MyRoutes.editScrollingNotice) {
    myLoadingDialog(context);
    String notice = '';
    DatabaseReference ref = FirebaseApi.connect.child('home/');
    final snapshot = await ref.child('scrolling_notice').get();
    notice = snapshot.value.toString();
    log(notice.toString());
    if (context.mounted) {
      Navigator.pop(context);
      notice = await showTextBoxDialog(context: context, presetValue: notice, title: 'স্ক্রোলিং নোটিশ পরিবর্তন।', data: 'এখানে আপনার নতুন নোটিশ লিখে, \'SAVE\' বাটন এ ক্লিক করুন');
    }
    if (snapshot.value.toString() != notice) {
      await ref.update({'scrolling_notice': notice});
      await sendNotification(title: 'নোটিশ:', description: notice, recipient: ROOT.defaultNoticeSubscriber);
      myToast(msg: 'notice updated...');
      if (context.mounted) Navigator.pushReplacementNamed(context, MyRoutes.home);
    }
    NavigationRoute.currentPage = MyRoutes.home;
  } else {
    Navigator.pushNamed(context, route);
  }
}
