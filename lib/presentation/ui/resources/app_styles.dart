import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';

import 'fonts.dart';

abstract class AppStyles {
  AppStyles._();

  static TextStyle getDefaultTextStyle({
    FontWeight weight = FontWeight.w700,
    double size = 12,
    double height = 1.0,
    Color color = AppColors.primaryColor,
  }) => TextStyle(
      color: color,
      fontFamily: Fonts.comfortaa,
      fontWeight: weight,
      fontSize: size,
      height: height
  );

  static TextStyle getDefaultBoldTextStyle({
    double size = 12,
    Color color = AppColors.primaryColor
  }) => getDefaultTextStyle(weight: FontWeight.w900, size: size, color: color);

  static TextStyle getWhiteInputFieldStyle({
    Color color = AppColors.inputFieldColor
  }) => getDefaultTextStyle(color: color);

  static TextStyle getWhiteInputFieldHintStyle() =>
      getWhiteInputFieldStyle(color: AppColors.inputFieldHintColor);
}
