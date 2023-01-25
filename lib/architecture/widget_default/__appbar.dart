import 'package:base/architecture/__colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../root/root.dart';

myAppBar(
        {required BuildContext context,
        String title = ROOT.institutionAbbreviation,
        List<Widget>? actions,
        double fontSize = 16,
        Color? foreground,
        Color? systemNavigationBarColor = MyColors.appDefaultBG,
        Color background = MyColors.appbarbackground}) =>
    AppBar(
        backgroundColor: background,
        systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: systemNavigationBarColor),
        title: Text(title, textScaleFactor: 1, style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: fontSize)),
        foregroundColor: foreground,
        // actions: [IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.news, size: 18))],
        actions: actions,
        titleSpacing: 0,
        toolbarHeight: 40,
        elevation: 0.0);


