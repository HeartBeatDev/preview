import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastUtils {
  ToastUtils._();

  static void showToast(String message,
      {Toast toastLength = Toast.LENGTH_LONG,
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color backgroundColor = AppColors.errorColor,
        Color textColor = Colors.white}) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 15.0);
  }
}