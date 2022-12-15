import 'package:flutter/cupertino.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';
import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class FinanceInvoiceDetailsView extends StatelessWidget {
  final FinanceInvoiceDetails financeInvoiceDetails;
  FinanceInvoiceDetailsView({required this.financeInvoiceDetails});

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
                  content: _tile("Overdue", financeInvoiceDetails.overDue!),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Current Due", financeInvoiceDetails.currentDue),
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
                  content: _tile("Invoiced", financeInvoiceDetails.invoiced),
                  backgroundColor: AppColors.lightYellow,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: PerformanceViewHolder(
                  content: _tile("Collected", financeInvoiceDetails.collected),
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

  Widget _tile(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
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
