import 'package:flutter/material.dart';

class MyDateUtil {
  //for getting formatted time from millisecondsinceEpoch String
  static String getFormattedTime(
    {required BuildContext context, required String time}) {
      final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
      return TimeOfDay.fromDateTime(date).format(context);
    }
}