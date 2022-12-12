import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceCashMonthlyList extends StatelessWidget{
  final List<String> entries = <String>['Jan', 'Feb', 'Mar'];
  final List<String> values = <String>['1.2M', '3M', '4M'];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return createList();


  }

  Widget _subTile(String icon,String label, String value ) {
    return Row(
      children: [
        Container(
            height: 35, width: 35, child: SvgPicture.asset(icon, width: 40, height: 40)),
        SizedBox(width: 4,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.textColorBlack),
            ),

          ],
        ),
      ],
    );
  }

  Widget createList() {
    return ListView.separated(

        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(child: Text(entries[index])),
              Expanded(child: _subTile('assets/icons/cash_in_icon.svg',values[index],values[index])),
              Expanded(child: _subTile('assets/icons/cash_out_icon.svg',values[index],values[index])),
            ],);

        },   separatorBuilder: (BuildContext context, int index) => const Divider());
  }

}