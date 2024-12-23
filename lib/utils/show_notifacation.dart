import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showNotification(String msg, bool isError) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      // gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: isError == true ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0
  );
}
