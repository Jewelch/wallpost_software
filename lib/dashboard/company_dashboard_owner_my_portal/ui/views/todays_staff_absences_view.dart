import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: _presenter.getTotalApprovalCount() > 0?0:20),

            Text(
              "${_presenter.getAbsenteesData().value}",
              style: TextStyles.extraLargeTitleTextStyleBold.copyWith(
                color: _presenter.getAbsenteesData().color,
              ),
            ),
            SizedBox(width: _presenter.getTotalApprovalCount() > 0?10:30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _presenter.getTotalApprovalCount() > 0?"Staff\nAbsences":"Staff Absences",

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
