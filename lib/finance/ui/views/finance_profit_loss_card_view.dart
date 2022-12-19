import 'package:flutter/material.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';
import 'package:wallpost/finance/ui/models/finance_dashboard_value.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../presenters/finance_dashboard_presenter.dart';

class FinanceProfitLossCardView extends StatelessWidget {
  final FinanceDashboardPresenter presenter;

  FinanceProfitLossCardView({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PerformanceViewHolder(
        padding: EdgeInsets.all(8),
        content: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PerformanceViewHolder(
                    content: _profitLossTile(presenter.getProfitAndLoss()),
                    backgroundColor: presenter.profitLossBoxColor() ,
                    showShadow: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PerformanceViewHolder(
                    content: _incomeAndExpenseTile(presenter.getIncome()),
                    backgroundColor: AppColors.lightGreen,
                    showShadow: false,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: PerformanceViewHolder(
                    content: _incomeAndExpenseTile(presenter.getExpenses()),
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

  Widget _profitLossTile(FinanceDashBoardValue financeDashBoardValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        addSubScriptWithText(financeDashBoardValue),
        SizedBox(height: 2),
        Text(
          financeDashBoardValue.label,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }
  Widget addSubScriptWithText(FinanceDashBoardValue financeDashBoardValue){
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text:  financeDashBoardValue.value,
            style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: financeDashBoardValue.valueColor)),
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(4, -10),
            child: Text(
              SelectedCompanyProvider().getSelectedCompanyForCurrentUser().currency,
              //superscript is usually smaller in size
              textScaleFactor: 0.7,
              style: TextStyle(color: financeDashBoardValue.valueColor,fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]),
    );
  }

  Widget _incomeAndExpenseTile(FinanceDashBoardValue financeDashBoardValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          financeDashBoardValue.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: financeDashBoardValue.valueColor),
        ),
        SizedBox(height: 2),
        Text(
          financeDashBoardValue.label,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }
}
