import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:flutter/material.dart';

class WhiteInputField extends StatelessWidget {

  final String hint;
  final bool isPassword;
  final double height;
  final Widget? rightView;
  final TextEditingController? controller;

  const WhiteInputField(this.hint,
      { this.controller,
        this.isPassword = false,
        this.height = 38,
        this.rightView,
        Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 38,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: _createInputField()
            ),
            if (rightView != null) SizedBox(width: 12),
            if (rightView != null) rightView!
          ],
        )
    );
  }

  Widget _createInputField() {
    return TextField(
        controller: controller,
        cursorColor: AppColors.inputFieldColor,
        cursorWidth: 1.5,
        maxLines: 1,
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hint,
          contentPadding: EdgeInsets.only(bottom: 8),
          hintStyle: AppStyles.getWhiteInputFieldHintStyle(),
        ),
        style: AppStyles.getWhiteInputFieldStyle()
    );
  }
}