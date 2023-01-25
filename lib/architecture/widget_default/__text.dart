import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

myText({
  required String? label,
  String? fontFamily = 'RobotoSlab',
  int maxLines = 1,
  int minLines = 1,
  double fontsize = 10,
  double maxFontsize = 16,
  double minFontsize = 6,
  double? height,
  double? letterSpacing,
  double? wordSpacing,
  TextAlign? textAlign,
  FontStyle? fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.w500,
  EdgeInsets padding = const EdgeInsets.all(0),
  Color? color,
}) =>
    Padding(
        padding: padding,
        child: AutoSizeText(label ?? '',
            maxFontSize: maxFontsize,
            minFontSize: minFontsize,
            stepGranularity: 0.1,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: textAlign,
            style: TextStyle(
                fontFamily: fontFamily,
                color: color,
                fontStyle: fontStyle,
                height: height,
                letterSpacing: letterSpacing,
                wordSpacing: wordSpacing,
                fontSize: fontsize,
                fontWeight: fontWeight)));
