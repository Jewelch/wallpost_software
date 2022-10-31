import 'package:flutter/material.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/owner_my_portal_dashboard_presenter.dart';
import 'module_box_view_holder.dart';

class TodaysStaffAbsencesView extends StatelessWidget {
  final OwnerMyPortalDashboardPresenter _presenter;

  TodaysStaffAbsencesView(this._presenter);

  @override
  Widget build(BuildContext context) {
    return _staffAbsencesTile();
  }

  Widget _staffAbsencesTile() {
    return ModuleBoxViewHolder(
      backgroundColor: Color.fromRGBO(243, 246, 249, 1.0),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_presenter.getAbsenteesData().value}",
              style: TextStyles.extraLargeTitleTextStyleBold.copyWith(
                color: _presenter.getAbsenteesData().color,
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Staff\nAbsences",
                  style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
                ),
                Text(
                  "Today",
                  style: TextStyles.labelTextStyleBold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
