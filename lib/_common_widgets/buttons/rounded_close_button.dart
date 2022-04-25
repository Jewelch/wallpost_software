import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';

class RoundedCloseButton extends RoundedIconButton {
  RoundedCloseButton({Color? iconColor, Color? backgroundColor, VoidCallback? onPressed})
      : super(
          iconName: 'assets/icons/close_icon.svg',
          iconSize: 18,
          onPressed: onPressed,
        );
}
