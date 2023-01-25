import 'package:flutter/material.dart';

class MyColors {
  // appbar
  static const Color appbarbackground = Colors.transparent;
  static const Color appbarforeground = Color.fromRGBO(255, 255, 255, 1);

  // Decision {positive, negative}
  static const Color negative = Color(0xffb00020);
  static const Color positive = Color.fromARGB(255, 89, 153, 88);
  static const Color newsPaper = Color.fromARGB(255, 245, 242, 232);

  // Item Details
  static Color itemDetailsBackground = const Color.fromARGB(255, 233, 218, 193);
  // Home
  // static Color homePageTimeHeaderBackground = const Color.fromARGB(255, 255, 227, 169);
  static const Color appDefaultBG = Color(0xff3b5998);
  static Color homePageTimeHeaderBackground = appbarbackground;
  static Color homePageTimeHeaderForeground = Colors.white;
  static Color homePageScrollingNoticeBackground = Colors.transparent;
  static Color homePageScrollingNoticeForeGround = Colors.white;
  static Color homePagePhotoSliderDotColor = const Color.fromARGB(255, 21, 114, 161);
  static Color homePagePhotoSliderActiveDotColor = Colors.red;

  // Notice List
  static Color noticeListBG = const Color.fromARGB(255, 126, 207, 192);
  static Color noticeTiles = const Color.fromARGB(255, 126, 207, 192);
  static Color noticeSenderDate = const Color.fromARGB(255, 126, 207, 192);
  // Notice Details
  static const Color noticeDetailsBoxBG = Color.fromARGB(255, 255, 251, 197);
  static Color cross = const Color.fromARGB(255, 245, 83, 83);

  // Routine Design
  static const Color routineDayNameBG = Color.fromARGB(255, 230, 186, 149);
  static const Color routineTimeBG = Color.fromARGB(255, 249, 235, 200);
}
