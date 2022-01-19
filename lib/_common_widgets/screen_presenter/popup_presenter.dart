import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class PopupPresenter {
  static Future<dynamic> present(
    Widget screen,
    BuildContext context,
    String title,
    VoidCallback? onCloseIconPressed(),
    VoidCallback? onDoneIconPressed(),
  ) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            insetPadding: EdgeInsets.fromLTRB(20, 70, 20, 80),
            content: Column(
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.labelColor,
                          ),
                          alignment: Alignment.centerLeft,
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onCloseIconPressed != null)
                              onCloseIconPressed();
                          },
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: IconButton(
                          alignment: Alignment.centerRight,
                          icon: Icon(Icons.done, color: AppColors.defaultColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onDoneIconPressed != null) onDoneIconPressed();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                screen,
              ],
            ),
          );
        });
  }
}
