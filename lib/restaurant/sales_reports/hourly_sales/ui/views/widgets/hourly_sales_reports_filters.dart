import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../../../../../_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../../_shared/date_range_selector/ui/widgets/single_date_selector.dart';
import '../../../entities/hourly_sales_report_filters.dart';
import '../../../entities/hourly_sales_report_sort_options.dart';

class HourlySalesReportsFilters extends StatefulWidget {
  final HourlySalesReportFilters filters;
  final ModalSheetController modalSheetController;
  final VoidCallback onResetClicked;

  const HourlySalesReportsFilters(
      {required this.filters, required this.modalSheetController, required this.onResetClicked});

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false,
      required HourlySalesReportFilters initialFilters,
      required VoidCallback onResetClicked}) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
        context: context,
        content: HourlySalesReportsFilters(
          filters: initialFilters,
          modalSheetController: modalSheetController,
          onResetClicked: onResetClicked,
        ),
        controller: modalSheetController,
        isCurveApplied: false);
  }

  @override
  State<HourlySalesReportsFilters> createState() => _HourlySalesReportsFiltersState();
}

class _HourlySalesReportsFiltersState extends State<HourlySalesReportsFilters> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24.0, right: 18, left: 18, top: 18),
      decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.transparent)),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => widget.modalSheetController.close(),
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
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.modalSheetController.close();
                    widget.onResetClicked();
                  },
                  child: Text(
                    "Reset",
                    style: TextStyles.largeTitleTextStyleBold.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
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
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                var newDate = await SingleDateSelector.show(
                  context,
                  initialDate: widget.filters.selectedDate,
                );
                if (newDate != null) {
                  widget.filters.selectedDate = newDate;
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldBackgroundColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.filters.selectedDate.toReadableString(),
                      style: TextStyles.subTitleTextStyleBold.copyWith(
                        color: AppColors.textColorDarkGray,
                      ),
                    ),
                    SvgPicture.asset("assets/icons/arrow_right_icon.svg"),
                  ],
                ),
              ),
            ),
            Divider(height: 50),
            Text(
              "Sort by",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              children: HourlySalesReportSortOptions.values
                  .map(
                    (sortOption) => RadioContainer(
                      title: sortOption.toReadableString(),
                      isSelected: widget.filters.sortOption == sortOption,
                      onTap: () {
                        widget.filters.sortOption = sortOption;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  onPressed: () {
                    widget.modalSheetController.close(result: widget.filters);
                  },
                  child: Text(
                    'Apply Changes',
                    style: TextStyles.largeTitleTextStyleBold.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.0,
                    ),
                  )),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class RadioContainer extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final bool isSelected;

  const RadioContainer({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, right: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.textFieldBackgroundColor), borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyles.labelTextStyle
                  .copyWith(color: isSelected ? AppColors.defaultColor : AppColors.textColorDarkGray, fontSize: 13.0),
            ),
            SizedBox(width: 16),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
              color: AppColors.defaultColor,
            ),
          ],
        ),
      ),
    );
  }
}
