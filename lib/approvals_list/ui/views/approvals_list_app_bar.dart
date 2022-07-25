import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../../_common_widgets/buttons/rounded_icon_button.dart';

class ApprovalsListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  @override
  final Size preferredSize;

  ApprovalsListAppBar({
    required this.onBackPressed,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      elevation: 1.0,
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _backButton(),
              SizedBox(width: 10),
              Center(
                  child: Row(
                children: [
                  Text(
                    "Approvals",
                    style: TextStyles.headerCardLargeTextStyle
                        .copyWith(color: AppColors.defaultColorDark),
                  )
                ],
              )),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedIconButton(
        iconName: 'assets/icons/back_icon.svg',
        onPressed: onBackPressed,
        iconSize: 10,
      ),
    );
  }
}
