import 'package:flutter/material.dart';

myCircularLoader(
        {Color color = Colors.white,
        double? height,
        double? width,
        double? value,
        double strock = 1.6,
        Color bakcground = Colors.black54,
        EdgeInsets padding = const EdgeInsets.all(0),
        bool showPercentage = false,
        Color percentageColor = const Color.fromARGB(255, 32, 19, 53)}) =>
    Container(
      alignment: Alignment.center,
      height: height,
      width: (width != null) ? width : height,
      child: Padding(
        padding: padding,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          clipBehavior: Clip.hardEdge,
          children: [
            CircularProgressIndicator(color: color, strokeWidth: strock, backgroundColor: bakcground, value: value
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
            if (showPercentage)
              Text('${(value! * 100).toStringAsFixed(0)}%',
                  maxLines: 1, style: TextStyle(fontFamily: 'Bitter', overflow: TextOverflow.fade, color: percentageColor, fontWeight: FontWeight.bold, fontSize: 8))
          ],
        ),
      ),
    );

myLinearLoader(
        {Color color = Colors.lightGreen,
        double? value,
        double strock = 4,
        Color bakcground = Colors.black54,
        EdgeInsets padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
        double percentageGap = 5,
        bool showPercentage = false,
        Color percentageColor = const Color.fromARGB(255, 32, 19, 53)}) =>
    Padding(
      padding: padding,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: percentageGap),
            child: ClipRRect(borderRadius: BorderRadius.circular(100), child: LinearProgressIndicator(backgroundColor: bakcground, color: color, value: value, minHeight: strock)),
          ),
          if (showPercentage)
            Text('${(value! * 100).toStringAsFixed(0)}%',
                maxLines: 1, style: TextStyle(fontFamily: 'Bitter', overflow: TextOverflow.fade, color: percentageColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
