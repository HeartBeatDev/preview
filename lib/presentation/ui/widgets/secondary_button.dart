import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {

  final String text;
  final GestureTapCallback onClick;
  final double width;

  const SecondaryButton(
      this.text,
      this.onClick,
      {this.width = 210, Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
          height: 38,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          padding: EdgeInsets.only(left: 16, right: 16, top: 2),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppStyles.getDefaultBoldTextStyle(size: 14, color: AppColors.primaryColor),
          )
      ),
    );
  }
}