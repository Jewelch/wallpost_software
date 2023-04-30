import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../text_styles/text_styles.dart';

class FiltersListView extends StatelessWidget {
  final List<Widget> filters;
  final VoidCallback onCancelButtonPressed;
  final VoidCallback onResetButtonPressed;
  final VoidCallback onApplyChangesButtonPressed;

  FiltersListView({
    required this.filters,
    required this.onCancelButtonPressed,
    required this.onResetButtonPressed,
    required this.onApplyChangesButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            padding: EdgeInsets.only(left: 8, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => onCancelButtonPressed(),
                  child: Text(
                    "Cancel",
                    style: TextStyles.largeTitleTextStyle.copyWith(color: AppColors.defaultColor),
                  ),
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    "Filter",
                    style: TextStyles.largeTitleTextStyle.copyWith(color: AppColors.textColorBlack),
                  ),
                ),
                TextButton(
                  onPressed: () => onResetButtonPressed(),
                  child: Text(
                    "Reset",
                    style: TextStyles.largeTitleTextStyle.copyWith(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: _buildChildren()),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RoundedRectangleActionButton(
              title: "Apply Changes",
              onPressed: () => onApplyChangesButtonPressed(),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> children = [];

    for (int i = 0; i < filters.length; i++) {
      children.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: filters[i],
        ),
      );
      if (i < filters.length - 1) children.add(Divider(height: 1));
    }
    children.add(SizedBox(height: 20));

    return children;
  }
}
