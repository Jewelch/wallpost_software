import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/item_sales_presenter.dart';

class ShareReportButton extends StatelessWidget {
  const ShareReportButton(
    this.presenter, {
    super.key,
  });

  final ItemSalesPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: presenter.changeViewWise,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: 1, blurRadius: 15)],
            ),
            child: Blur(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: .7,
                child: Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                    color: AppColors.screenBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/share_icon.svg",
                height: 20,
                width: 18,
              ),
              SizedBox(width: 11),
              Text(
                'Share Report',
                style: TextStyles.largeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
