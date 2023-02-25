import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../_shared/date_range_selector/date_range_filters.dart';
import '../../../../../_shared/date_range_selector/date_range_selector.dart';

class RestaurantFilters extends StatelessWidget {
  final DateRangeFilters dateFilters;
  final ModalSheetController modalSheetController;

  const RestaurantFilters({required this.dateFilters, required this.modalSheetController});

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false, required DateRangeFilters initialDateRangeFilter}) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
        context: context,
        content: RestaurantFilters(
          dateFilters: initialDateRangeFilter,
          modalSheetController: modalSheetController,
        ),
        controller: modalSheetController,
        isCurveApplied: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.0, right: 18, left: 18, top: 18),
      decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.transparent)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    "Cancel",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    "Filters",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "By Date",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                var newDateFilter = await DateRangeSelector.show(
                  context,
                  initialDateRangeFilter: dateFilters,
                );
                if (newDateFilter != null) modalSheetController.close(result: newDateFilter);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldBackgroundColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFilters.toReadableString(),
                      style: TextStyles.subTitleTextStyleBold.copyWith(
                        color: AppColors.textColorDarkGray,
                      ),
                    ),
                    SvgPicture.asset("assets/icons/arrow_right_icon.svg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
