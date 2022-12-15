import 'package:flutter/cupertino.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';
import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class FinanceBillDetailsView extends StatelessWidget {
  final FinanceBillDetails financeBillDetails;

  FinanceBillDetailsView({required this.financeBillDetails});

  @override
  Widget build(BuildContext context) {
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
                  content: _tile("Overdue", financeBillDetails.overDue),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Current Due", financeBillDetails.currentDue),
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
                  content: _tile("Billed", financeBillDetails.billed),
                  backgroundColor: AppColors.lightYellow,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Paid", financeBillDetails.paid),
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

  Widget _tile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }
}
