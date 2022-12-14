import 'package:flutter/cupertino.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';
import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class BillBoxView extends StatelessWidget {  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _dataView();
  }


Widget _dataView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: PerformanceViewHolder(
                content: _tile(),
                backgroundColor: AppColors.lightGreen,
                showShadow: false,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: PerformanceViewHolder(
                content: _tile(),
                backgroundColor: AppColors.lightGreen,
                showShadow: false,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 8),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: PerformanceViewHolder(
                content: _tile(),
                backgroundColor: AppColors.lightYellow,
                showShadow: false,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: PerformanceViewHolder(
                content: _tile(),
                backgroundColor: AppColors.lightYellow,
                showShadow: false,
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget _tile() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '50000',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
      ),
      SizedBox(height: 2),
      Text(
        'Invoiced',
        style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
      )
    ],
  );
}
}
