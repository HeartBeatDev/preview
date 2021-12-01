import 'package:Hercules/presentation/ui/resources/app_colors.dart';
import 'package:Hercules/presentation/ui/resources/app_styles.dart';
import 'package:Hercules/presentation/ui/resources/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordDialog extends StatefulWidget {

  final Function(String) sendAction;

  ForgotPasswordDialog(this.sendAction);

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {

  final _emailFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: _createContent(),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.only(right: 16, bottom: 16),
              child: Text(
                LocaleKeys.close.tr(),
                style: AppStyles.getDefaultBoldTextStyle(
                    size: 14, color: AppColors.lightGreyTextColor),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final email = _emailFieldController.text;
              if (email.isNotEmpty) {
                Navigator.pop(context);
                widget.sendAction(email);
              }
            },
            child: Container(
              padding: EdgeInsets.only(right: 16, bottom: 16),
              child: Text(
                LocaleKeys.send.tr(),
                style: AppStyles.getDefaultBoldTextStyle(size: 14),
              ),
            ),
          )
        ],
        insetPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));
  }

  Widget _createContent() {
    final outlineBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.inputFieldHintColor, width: 1)
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        Text(
          LocaleKeys.resetPasswordDescription.tr(),
          textAlign: TextAlign.center,
          style: AppStyles.getDefaultTextStyle(
              size: 14, color: AppColors.inputFieldColor),
        ),
        SizedBox(height: 24),
        TextField(
            controller: _emailFieldController,
            cursorColor: AppColors.inputFieldColor,
            cursorWidth: 1.5,
            maxLines: 1,
            decoration: InputDecoration(
              border: outlineBorder,
              focusedBorder: outlineBorder,
              enabledBorder: outlineBorder,
              errorBorder: outlineBorder,
              disabledBorder: outlineBorder,
              hintText: LocaleKeys.email.tr(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hintStyle: AppStyles.getWhiteInputFieldHintStyle(),
            ),
            style: AppStyles.getWhiteInputFieldStyle()),
      ],
    );
  }

  @override
  void dispose() {
    _emailFieldController.dispose();
    super.dispose();
  }
}
