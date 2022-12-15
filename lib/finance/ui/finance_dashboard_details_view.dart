import 'package:flutter/material.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceDashBoardDetailsView extends StatelessWidget {
  final String profitAndLoss;
  final String income;
  final String expense;

  FinanceDashBoardDetailsView({required this.profitAndLoss, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return _datView();
  }

  Widget _datView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PerformanceViewHolder(
        content: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PerformanceViewHolder(
                    content: _profitAndLossTile(profitAndLoss),
                    backgroundColor:profitAndLoss.contains("-") ? AppColors.lightRed : AppColors.lightGreen,
                    showShadow: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: PerformanceViewHolder(
                    content: _incomeAndExpenseTile(income, "Income",AppColors.green),
                    backgroundColor: AppColors.lightGreen,
                    showShadow: false,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: PerformanceViewHolder(
                    content: _incomeAndExpenseTile(expense, "Expense",AppColors.red),
                    backgroundColor: AppColors.lightRed,
                    showShadow: false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _profitAndLossTile(String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.extraLargeTitleTextStyleBold
              .copyWith(color: amount.contains("-") ? AppColors.red : AppColors.green),
        ),
        SizedBox(height: 2),
        Text(
          amount.contains("-") ? "Loss This Year" : "Profit This Year",
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }

  Widget _incomeAndExpenseTile(String amount, String label,Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: color),
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
