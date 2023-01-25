import 'package:flutter/material.dart';

myLoadingDialog(BuildContext context) => showDialog(
    useSafeArea: true,
    barrierDismissible: false,
    context: context,
    builder: (_) => Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.10,
          height: MediaQuery.of(context).size.width * 0.10,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.grey,
          ),
        )));
