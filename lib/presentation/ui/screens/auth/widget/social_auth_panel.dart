import 'dart:io';
import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:Hercules/presentation/ui/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../social_auth_type.dart';

class SocialAuthPanel extends StatelessWidget {

  final Function(SocialAuthType) onClick;
  final String title;

  SocialAuthPanel(this.title, this.onClick);

  @override
  Widget build(BuildContext context) {
    bool isAppleEnabled = Platform.isIOS;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(child: Divider(height: 2, color: AppColors.lightGreyTextColor)),
            SizedBox(width: 16),
            Text(
                title,
                style: AppStyles.getDefaultTextStyle(color: AppColors.lightGreyTextColor)
            ),
            SizedBox(width: 16),
            Expanded(child: Divider(height: 2, color: AppColors.lightGreyTextColor)),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: isAppleEnabled
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceEvenly,
          children: [
            _createSocialAuthButton(
                SvgPicture.asset(Images.icGoogle, height: 20, width: 20),
                SocialAuthType.google),
            _createSocialAuthButton(
                SvgPicture.asset(Images.icFacebook, height: 22, width: 22),
                SocialAuthType.facebook),
            if (isAppleEnabled)
              _createSocialAuthButton(
                  Container(
                    padding: EdgeInsets.only(bottom: 2),
                    child: SvgPicture.asset(Images.icApple, height: 22, width: 22),
                  ),
                  SocialAuthType.ios)
          ],
        ),
        SizedBox(height: 40)
      ],
    );
  }

  Widget _createSocialAuthButton(Widget logo, SocialAuthType type) {
    return GestureDetector(
      onTap: () => onClick(type),
      child: Container(
          height: 40,
          width: 85,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.socialButtonOutlineColor),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: logo),
    );
  }
}
