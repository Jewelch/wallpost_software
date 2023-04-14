import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';
import '../../presenters/crm_dashboard_presenter.dart';

class CrmDashboardFiltersBar extends StatelessWidget {
  final CrmDashboardPresenter presenter;

  CrmDashboardFiltersBar(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Container(
        height: 52,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18),
              child: GestureDetector(
                onTap: () => presenter.initiateYTDFilterSelection(),
                child: SvgPicture.asset(
                  "assets/icons/filter_icon.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () => presenter.initiateYTDFilterSelection(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Text(
                  "${presenter.getSelectedMonthName()}",
                  style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () => presenter.initiateYTDFilterSelection(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Text(
                  "${presenter.getSelectedYear()}",
                  style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
