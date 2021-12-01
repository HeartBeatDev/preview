import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: AppColors.progressIndicatorBgColor,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        )
    );
  }
}
