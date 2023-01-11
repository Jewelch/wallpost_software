import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../../../../_shared/date_range_selector/date_range_selector.dart';
import '../../../entities/item_sales_report_filters.dart';
import '../../../entities/item_sales_report_sort_options.dart';
import '../../../entities/sales_item_view_options.dart';

class RestaurantReportsFilters extends StatefulWidget {
  final ItemSalesReportFilters filters;
  final ModalSheetController modalSheetController;

  const RestaurantReportsFilters({required this.filters, required this.modalSheetController});

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false, required ItemSalesReportFilters initialFilters}) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
        context: context,
        content: RestaurantReportsFilters(
          filters: initialFilters,
          modalSheetController: modalSheetController,
        ),
        controller: modalSheetController,
        isCurveApplied: false);
  }

  @override
  State<RestaurantReportsFilters> createState() => _RestaurantReportsFiltersState();
}

class _RestaurantReportsFiltersState extends State<RestaurantReportsFilters> {
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
                  onPressed: () {},
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
                var newDateFilter = await DateRangeSelector.show(
                  context,
                  onDateRangeFilterSelected: (_) {},
                  initialDateRangeFilter: widget.filters.dateRangeFilters,
                );
                if (newDateFilter != null) {
                  widget.filters.dateRangeFilters = newDateFilter;
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
                      widget.filters.dateRangeFilters.selectedRangeOption.toReadableString(),
                      style: TextStyles.subTitleTextStyleBold.copyWith(
                        color: AppColors.textColorDarkGray,
                      ),
                    ),
                    SvgPicture.asset("assets/icons/arrow_right_icon.svg"),
                  ],
                ),
              ),
            ),
            Divider(height: 24 * 2),
            Text(
              "View as",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              direction: Axis.horizontal,
              children: SalesItemWiseOptions.values
                  .map(
                    (wise) => RadioContainer(
                      title: wise.toReadableString(),
                      isSelected: widget.filters.salesItemWiseOptions == wise,
                      onTap: () {
                        widget.filters.salesItemWiseOptions = wise;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            Divider(height: 24 * 2),
            Text(
              "Sort by",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              children: [ItemSalesReportSortOptions.values.first, ItemSalesReportSortOptions.values[1]]
                  .map(
                    (sortOption) => RadioContainer(
                      title: sortOption.toReadableString(),
                      isSelected: widget.filters.sortOptions == sortOption,
                      onTap: () {
                        widget.filters.sortOptions = sortOption;
                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
            Wrap(
              children: [ItemSalesReportSortOptions.values[2], ItemSalesReportSortOptions.values.last]
                  .map(
                    (sortOption) => RadioContainer(
                      title: sortOption.toReadableString(),
                      isSelected: widget.filters.sortOptions == sortOption,
                      onTap: () {
                        widget.filters.sortOptions = sortOption;
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
