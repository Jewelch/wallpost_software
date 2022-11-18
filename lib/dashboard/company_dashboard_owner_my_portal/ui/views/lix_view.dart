import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../../../../lix/lix_details.dart';
import '../../../../lix/lix_slider_one.dart';
import '../presenters/owner_my_portal_dashboard_presenter.dart';

class LixView extends StatelessWidget {

  LixView();

  @override
  Widget build(BuildContext context) {
    return _lixTile(context);
  }

  Widget _lixTile(BuildContext context) {
    return GestureDetector(
      onTap: (){
        ScreenPresenter.present(LixInnerPage(),context);
      },
      child: PerformanceViewHolder(
        showShadow: false,
        backgroundColor: AppColors.lightGray,
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    height: 50, width: 50, child: SvgPicture.asset('assets/icons/lix_icon.svg', width: 40, height: 40)),
              ),
              SizedBox(width: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "0",
                    style: TextStyles.largeTitleTextStyleBold,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "LIX Token Been Awarded!",
                    style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    "COMING SOON!",
                    style: TextStyles.labelTextStyle.copyWith(color: AppColors.yellow),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
