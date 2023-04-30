import 'package:flutter/material.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../text_styles/text_styles.dart';
import '../radio_group.dart';

class FiltersListViewRadioGroupFilter extends StatelessWidget {
  final String filterTitle;
  final RadioGroup radioGroup;

  const FiltersListViewRadioGroupFilter({
    required this.filterTitle,
    required this.radioGroup,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filterTitle,
            style: TextStyles.largeTitleTextStyle.copyWith(
              color: AppColors.textColorBlack,
            ),
          ),
          SizedBox(height: 16),
          radioGroup,
        ],
      ),
    );
  }
}
