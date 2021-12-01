import 'package:Hercules/presentation/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget child;

  const UnfocusWidget({Key? key, required this.child}) : super(key: key);

  // Functions
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UiUtils.unfocus(context);
      },
      child: child,
    );
  }
}