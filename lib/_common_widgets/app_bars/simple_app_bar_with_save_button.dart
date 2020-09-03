import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SimpleAppBarWithSaveButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPress;
  final VoidCallback submitPress;

  @override
  final Size preferredSize = Size.fromHeight(56);

  SimpleAppBarWithSaveButton(
      {this.title, this.onBackButtonPress, this.submitPress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // Don't show the leading button
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onBackButtonPress();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.defaultColor),
            ),
          ),
          //This container is added to center the title
          Container(
            width: 30,
            height: 30,
          ),
          // Your widgets here
        ],
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.all(12),
          child: CircleAvatar(
            backgroundColor: AppColors.defaultColor,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 19,
                ),
                onPressed: () {
                  submitPress();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
