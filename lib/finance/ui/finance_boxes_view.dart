import 'package:flutter/material.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceBoxesView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return _datView();
  }

  Widget _datView() {
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
                    content: _tile(),
                    backgroundColor: AppColors.lightGreen,
                    showShadow: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(children: [

              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(),
                  backgroundColor: AppColors.lightGreen,
                  showShadow: false,
                ),
              ),
              SizedBox(width: 8,),

              Expanded(
                child: PerformanceViewHolder(
                  content: _tile(),
                  backgroundColor: AppColors.lightRed,
                  showShadow: false,
                ),
              ),
            ],)
          ],
        ),
      ),
   );
  }

  Widget _tile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
         "500000000",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.textColorBlack),
        ),
        SizedBox(height: 2),
        Text(
          "Profit This Year",
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
        )
      ],
    );
  }
}