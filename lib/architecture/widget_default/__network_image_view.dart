import '__loadings.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

myNetworkImage({
  required String imageurl,
  BoxFit fit = BoxFit.cover,
  double radius = 0,
  double? height,
  double? width,
  EdgeInsets? margin,
  EdgeInsets? padding,
  FilterQuality filter = FilterQuality.high,
  bool showloading = true,
}) =>
    ClipRRect(
      child: Container(
          height: height,
          width: width,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
          child: CachedNetworkImage(
            filterQuality: filter,
            imageUrl: imageurl,
            // height: height,
            fit: fit,
            alignment: Alignment.center,
            width: double.infinity,
            placeholder: showloading ? (context, url) => myCircularLoader(height: height) : null,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            // progressIndicatorBuilder: (context, url, progress) => myCircularLoader(height: height, value: (progress.totalSize! / progress.downloaded))
          )),
    );
