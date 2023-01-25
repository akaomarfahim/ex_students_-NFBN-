import 'package:fluttertoast/fluttertoast.dart';

myToast({required String msg, double fontSize = 13, ToastGravity toastGravity = ToastGravity.SNACKBAR}) => {
      Fluttertoast.cancel(),
      Fluttertoast.showToast(msg: msg, fontSize: fontSize, toastLength: Toast.LENGTH_SHORT, gravity: toastGravity),
    };
