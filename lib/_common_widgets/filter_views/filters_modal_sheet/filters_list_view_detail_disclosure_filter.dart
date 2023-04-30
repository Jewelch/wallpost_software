import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../text_styles/text_styles.dart';

class FiltersListViewDetailDisclosureFilter extends StatelessWidget {
  final String filterTitle;
  final String itemTitle;
  final VoidCallback onPressed;

  const FiltersListViewDetailDisclosureFilter({
    required this.filterTitle,
    required this.itemTitle,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filterTitle,
          style: TextStyles.largeTitleTextStyle.copyWith(
            color: AppColors.textColorBlack,
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () => onPressed.call(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textFieldBackgroundColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemTitle,
                  style: TextStyles.subTitleTextStyleBold.copyWith(
                    color: AppColors.textColorDarkGray,
                  ),
                ),
                SvgPicture.asset("assets/icons/arrow_right_icon.svg"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
