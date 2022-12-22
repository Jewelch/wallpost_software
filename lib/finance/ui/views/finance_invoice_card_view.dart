import 'package:flutter/cupertino.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class FinanceInvoiceCardView extends StatelessWidget {
  final FinanceInvoiceDetails financeInvoiceDetails;

  FinanceInvoiceCardView({required this.financeInvoiceDetails});

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
                  content: _tile("Overdue", financeInvoiceDetails.overDue, AppColors.red),
                  backgroundColor: AppColors.lightRed,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Current Due", financeInvoiceDetails.currentDue, AppColors.yellow),
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
                  content: _tile("Invoiced", financeInvoiceDetails.invoiced, AppColors.textColorBlack),
                  backgroundColor: AppColors.lightGray,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Collected", financeInvoiceDetails.collected, AppColors.green),
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

  Widget _tile(String label, String amount, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: textColor, fontWeight: FontWeight.w500),
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
