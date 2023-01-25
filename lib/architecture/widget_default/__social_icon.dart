import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

socialIcon({
  IconData icon = (Icons.web),
  double? iconSize,
  double? height,
  double? width,
  EdgeInsets? padding,
  EdgeInsets? margin,
  String? link,
}) {
  var uri = Uri.tryParse(link ?? '');
  return (uri != null || link != null || link != '')
      ? Container(
          height: height,
          width: width,
          padding: padding,
          margin: margin,
          child: IconButton(onPressed: () => launchUrl(uri!, mode: LaunchMode.externalApplication), icon: Icon(icon, size: iconSize)),
        )
      : Container();
}
