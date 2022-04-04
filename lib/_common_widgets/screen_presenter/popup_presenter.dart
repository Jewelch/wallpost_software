import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class PopupPresenter {
  static Future<dynamic> present({
    required BuildContext context,
    required Widget screen,
    required String title,
    VoidCallback? onDoneButtonPressed,
    VoidCallback? onCloseButtonPressed,
  }) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 80),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                CircularIconButton(
                  iconName: 'assets/icons/close_icon.svg',
                  color: Colors.white,
                  iconColor: AppColors.darkGrey,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCloseButtonPressed != null) onCloseButtonPressed();
                  },
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CircularIconButton(
                  iconName: 'assets/icons/check_mark_icon.svg',
                  color: Colors.white,
                  iconColor: AppColors.defaultColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onDoneButtonPressed != null) onDoneButtonPressed();
                  },
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: screen,
          ),
        );
      },
    );
  }
}
