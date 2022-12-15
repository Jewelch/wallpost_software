import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';
import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

class FinanceCashDetailAggregated extends StatelessWidget{
  final String bankAndCash;
  final String cashIn;
  final String cashOut;


  FinanceCashDetailAggregated({required this.bankAndCash,required this.cashIn,required this.cashOut});

  @override
  Widget build(BuildContext context) {
    return (
       Column(children: [
        _tile(),
        SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
          Expanded(child: _subTile('assets/icons/cash_in_icon.svg','Cash In',cashIn)),
            Expanded(child: _subTile('assets/icons/cash_out_icon.svg','Cash Out',cashOut)),
        ],)
      ])
    );
  }

  Widget _tile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          bankAndCash,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: AppColors.green),
        ),
        SizedBox(height: 2),
        Text(
          "Available Balance In Bank/Cash",
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }

  Widget _subTile(String icon,String label, String value ) {
    return Row(
      children: [
        Container(
        height: 35, width: 35, child: SvgPicture.asset(icon, width: 50, height: 50)),
       SizedBox(width: 4,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.textColorBlack),
              ),
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