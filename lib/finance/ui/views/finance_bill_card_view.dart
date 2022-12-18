import 'package:flutter/cupertino.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class FinanceBillCardView extends StatelessWidget {
  final FinanceBillDetails financeBillDetails;

  FinanceBillCardView({required this.financeBillDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Overdue", financeBillDetails.overDue, AppColors.red),
                  backgroundColor: AppColors.lightRed,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Current Due", financeBillDetails.currentDue, AppColors.yellow),
                  backgroundColor: AppColors.lightYellow,
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
                  content: _tile("Billed", financeBillDetails.billed, AppColors.textColorBlack),
                  backgroundColor: AppColors.lightGray,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Paid", financeBillDetails.paid, AppColors.green),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _tile(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: textColor),
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
