import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';

class FinanceCashDetailAggregated extends StatelessWidget {
  final String bankAndCash;
  final String cashIn;
  final String cashOut;

  FinanceCashDetailAggregated({required this.bankAndCash, required this.cashIn, required this.cashOut});

  @override
  Widget build(BuildContext context) {
    return (Column(children: [
      SizedBox(height: 8,),
      _bankAndCashTile(),
      SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 35,right : 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _cashInAndCashOutTile('assets/icons/cash_in_icon.svg', 'Cash In', cashIn)),
            Expanded(child: _cashInAndCashOutTile('assets/icons/cash_out_icon.svg', 'Cash Out', cashOut)),
          ],
        ),
      )
    ]));
  }

  Widget _bankAndCashTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          bankAndCash,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.extraLargeTitleTextStyleBold
              .copyWith(color: bankAndCash.contains("-") ? AppColors.red : AppColors.green),
        ),
        SizedBox(height: 2),
        Text(
          "Available Balance In Bank/Cash",
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }

  Widget _cashInAndCashOutTile(String icon, String label, String value) {
    return Row(
      children: [
        Container(
          child: SvgPicture.asset(icon, width: 28, height: 28),
        ),
        SizedBox(
          width: 6,
        ),
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
            Text(
              label,
              style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
            )
          ],
        ),
      ],
    );
  }
}
