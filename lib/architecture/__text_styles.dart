import 'package:flutter/material.dart';
import '__colors.dart';

class TextStyleFor {
  // Basic
  static const TextStyle basic = TextStyle(fontFamily: 'RobotoSlab', color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12);

  // appbar
  // static TextStyle appBar = const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 16);

  // Button
  static TextStyle button = const TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);

  // My TextField
  static const photoSlideTextField = TextStyle(fontFamily: 'RobotoSlab', fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);

  // There noting to show
  static TextStyle nothingToShow = const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Bitter', fontWeight: FontWeight.w400, letterSpacing: 0.4, wordSpacing: 1.5);
  static TextStyle nothingToShowDark = const TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'Bitter', fontWeight: FontWeight.w400, letterSpacing: 0.4, wordSpacing: 1.5);

  // Dialog
  static const TextStyle dialogTitle = TextStyle(fontFamily: 'RobotoSlab', fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle dialogdescription = TextStyle(fontFamily: 'Ubuntu', fontSize: 13, fontWeight: FontWeight.normal);

  // Navigation Drawer
  // ---- Header
  static const TextStyle navigationDrawerHeaderTitle = TextStyle(fontFamily: 'RobotoSlab', color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14);
  static const TextStyle navigationDrawerHeaderSubtitle = TextStyle(fontFamily: 'Nunito', color: Colors.black, fontWeight: FontWeight.w500, fontSize: 10);
  // ---- Menu
  static const TextStyle navigationDrawerMenu = TextStyle(fontFamily: 'Gentium', fontWeight: FontWeight.w600, fontSize: 12);
  static const TextStyle navigationDrawerMenuParent = TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'RobotoSlab', fontWeight: FontWeight.w500);

  // Home
  static TextStyle homePageTimeHeader = TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w700, fontSize: 12, color: MyColors.homePageTimeHeaderForeground);
  static const TextStyle homePageScrollingNotice = TextStyle(
    fontFamily: 'TiroBangla',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: Colors.white,
  );
  // Chairman & Principal
  static TextStyle chairmanPrinciaplDesignation = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'Bitter', fontSize: 10);
  static TextStyle chairmanPrinciapl = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'Bitter', fontSize: 14);
  static TextStyle details = const TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontFamily: 'Nunito', fontSize: 10);
  // News Box
  static TextStyle newsBoxTitle = const TextStyle(fontFamily: 'Bitter', fontSize: 10, color: Colors.black, fontWeight: FontWeight.w700, overflow: TextOverflow.clip);
  static TextStyle newsBoxDescription = const TextStyle(fontFamily: 'RobotoSlab', fontSize: 11, color: Colors.black, fontWeight: FontWeight.w400, overflow: TextOverflow.clip);

  // Item Details
  static TextStyle itemDetailsTitle = const TextStyle(fontFamily: 'RobotoSlab', fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle itemDetailsDescription =
      const TextStyle(fontFamily: 'RobotoSlab', height: 1.3, overflow: TextOverflow.visible, fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);

  // Notice
  // Notice Tile
  static const TextStyle noticeTileTitle = TextStyle(fontSize: 12, fontFamily: 'RobotoSlab', fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis);
  static const TextStyle noticeTileDescription = TextStyle(fontFamily: 'RobotoSlab', overflow: TextOverflow.ellipsis, height: 1.2, fontWeight: FontWeight.w400, fontSize: 11);
  static const TextStyle noticeTileSenderAndDate = TextStyle(fontSize: 9, fontFamily: 'Nunito', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold);
  // ---- Sign In
  static const TextStyle signInPageInstitutionName = TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle signInPageInstitutionMoto = TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w400);
}
