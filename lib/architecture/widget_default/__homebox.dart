// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Styles {
  static homeBoxTextStyle() {
    return TextStyle(
      fontFamily: 'RobotoSlab',
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade700,
      fontSize: 12,
      overflow: TextOverflow.clip,
    );
  }
}

class HomeBox extends StatelessWidget {
  final String title;
  final String title2;
  final double? height;
  final double width;
  // final bool isContainer;
  final bool buttonWithList;
  final Widget buttonWidget;
  final List<String> list;
  final Widget? container;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColors;
  final Color borderColor;
  final double borderRadius;
  final BorderRadius? customBorder;
  final Border? border;
  final VoidCallback? action;
  const HomeBox({
    Key? key,
    this.title = '',
    this.title2 = '',
    this.height,
    this.width = double.infinity,
    this.buttonWithList = false,
    this.buttonWidget = const SizedBox(),
    this.list = const [],
    this.container,
    this.margin = const EdgeInsets.all(6),
    this.padding = const EdgeInsets.all(8),
    this.backgroundColors = Colors.black87,
    this.borderColor = Colors.white,
    this.borderRadius = 4,
    this.customBorder,
    this.border,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      radius: 6,
      child: Container(
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: (border != null) ? border : Border.all(width: 1, color: borderColor),
              color: backgroundColors,
              borderRadius: (customBorder != null) ? customBorder : BorderRadius.circular(borderRadius)),
          child: Column(children: [
            title.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontFamily: 'RobotoSlab', fontWeight: FontWeight.w500)),
                        Text(title2, style: const TextStyle(fontFamily: 'RobotoSlab', fontWeight: FontWeight.w500)),
                        // Text(
                        //   'taka',
                        //   style: const TextStyle(fontFamily: 'RobotoSlab', fontWeight: FontWeight.w500),
                        // )
                      ],
                    ),
                  )
                : Container(),
            title.isNotEmpty
                ? SizedBox(
                    child: Divider(
                      height: 0,
                      thickness: 0.7,
                      color: Colors.grey.shade500,
                    ),
                  )
                : Container(),
            (container == null)
                ? Container(
                    padding: const EdgeInsets.all(1),
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: list.length ~/ 2,
                            itemBuilder: (context, index) {
                              int d = list.length ~/ 2;
                              return ListTile(
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                horizontalTitleGap: 0,
                                minVerticalPadding: 0,
                                minLeadingWidth: 0,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  list[index],
                                  style: Styles.homeBoxTextStyle(),
                                ),
                                trailing: Text(
                                  list.isNotEmpty ? list[d + index] : '',
                                  style: Styles.homeBoxTextStyle(),
                                ),
                              );
                            }),
                        buttonWithList ? buttonWidget : Container()
                      ],
                    ))
                : Container(child: container)
          ])),
    );
  }
}
