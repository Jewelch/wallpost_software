import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../models/finance_dashboard_value.dart';

class FinanceCashCardView extends StatelessWidget {
  final FinanceDashboardPresenter presenter;

  FinanceCashCardView({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return (Column(children: [
      SizedBox(height: 8),
      _bankAndCashTile(presenter.getCashInBank()),
      SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.only(left: 35, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _cashInAndCashOutTile('assets/icons/cash_in_icon.svg', 'Cash In', presenter.getCashIn())),
            Expanded(
                child: _cashInAndCashOutTile('assets/icons/cash_out_icon.svg', 'Cash Out', presenter.getCashOut())),
          ],
        ),
      )
    ]));
  }

  Widget _bankAndCashTile(FinanceDashBoardValue financeDashBoardValue) {
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

  Widget _cashInAndCashOutTile(String icon, String label, String value) {
    return Row(
      children: [
        Container(child: SvgPicture.asset(icon, width: 28, height: 28)),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.textColorBlack),
            ),
            SizedBox(height: 2),
            Text(label, style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack))
          ],
        ),
      ],
    );
  }
}
