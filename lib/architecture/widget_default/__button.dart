import 'package:flutter/material.dart';
import '__loadings.dart';

myButton({
  String? label,
  bool isLoadingComplete = true,
  IconData? icon,
  Color? iconColor,
  Color? foreground = Colors.white,
  Color? background = Colors.blueGrey,
  Color? disabledForeground = Colors.white38,
  Color? disabledBackground = Colors.black38,
  Color borderColor = Colors.transparent,
  Color? shadowColor = Colors.transparent,
  double? iconSize = 18,
  double? height = 35,
  double? width = double.infinity,
  double elevation = 2,
  double borderRadius = 4,
  double borderWidth = 0,
  double? fontSize = 14,
  String? fontfamily = 'Ubuntu',
  EdgeInsets? margin,
  FontWeight fontWeight = FontWeight.w500,
  VoidCallback? action,
  InteractiveInkFeatureFactory splashFactory = InkSparkle.constantTurbulenceSeedSplashFactory,
}) =>
    Container(
        margin: margin,
        width: width,
        height: height,
        color: (label == null && icon != null) ? background : null,
        child: (icon != null && label != null)
            ? ElevatedButton.icon(
                icon: Icon(icon, size: iconSize, color: iconColor),
                clipBehavior: Clip.hardEdge,
                onPressed: (action == null || !isLoadingComplete) ? null : () => action(),
                style: ElevatedButton.styleFrom(
                    elevation: elevation,
                    foregroundColor: foreground,
                    backgroundColor: background,
                    disabledForegroundColor: disabledForeground,
                    disabledBackgroundColor: disabledBackground,
                    alignment: Alignment.center,
                    splashFactory: splashFactory,
                    visualDensity: VisualDensity.comfortable,
                    side: BorderSide(width: borderWidth, color: borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
                label: !isLoadingComplete ? myCircularLoader(height: 20) : Text(label, style: TextStyle(fontFamily: fontfamily, fontSize: fontSize, fontWeight: fontWeight)))
            : (label != null && icon == null)
                ? ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    onPressed: (action == null || !isLoadingComplete) ? null : () => action(),
                    style: ElevatedButton.styleFrom(
                        shadowColor: shadowColor,
                        elevation: elevation,
                        foregroundColor: foreground,
                        backgroundColor: background,
                        disabledForegroundColor: disabledForeground,
                        disabledBackgroundColor: disabledBackground,
                        alignment: Alignment.center,
                        splashFactory: splashFactory,
                        visualDensity: VisualDensity.comfortable,
                        side: BorderSide(width: borderWidth, color: borderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
                    child: !isLoadingComplete ? myCircularLoader(height: 20) : Text(label, style: TextStyle(fontFamily: fontfamily, fontSize: fontSize, fontWeight: fontWeight)))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: IconButton(
                        icon: !isLoadingComplete ? myCircularLoader(height: 20) : Icon(icon, size: iconSize, color: foreground),
                        onPressed: (action == null || !isLoadingComplete) ? null : () => action(),
                        style: ElevatedButton.styleFrom(
                            elevation: elevation,
                            foregroundColor: foreground,
                            backgroundColor: background,
                            disabledForegroundColor: disabledForeground,
                            disabledBackgroundColor: disabledBackground,
                            alignment: Alignment.center,
                            splashFactory: splashFactory,
                            visualDensity: VisualDensity.comfortable,
                            side: BorderSide(width: borderWidth, color: borderColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))))),
                  ));
