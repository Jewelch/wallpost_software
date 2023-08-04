import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../entities/date_range.dart';
import '../../entities/selectable_date_range_option.dart';
import '../presenters/date_range_presenter.dart';
import 'custom_date_range_selector.dart';

class FinanceDateRangeSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;

  final FinanceDateRangePresenter initialDateFilters;

  FinanceDateRangeSelector({required this.centerSheetController, required this.initialDateFilters, Key? key})
      : super(key: key);

  static Future<dynamic> show(
    BuildContext context, {
    bool allowMultiple = false,
    required FinanceDateRange initialDateRange,
  }) {
    var centerSheetController = CenterSheetController();
    var dateRangeFilters = FinanceDateRangePresenter();
    dateRangeFilters.dateRange = initialDateRange.copy();
    return CenterSheetPresenter.present(
      context: context,
      content:
          FinanceDateRangeSelector(centerSheetController: centerSheetController, initialDateFilters: dateRangeFilters),
      controller: centerSheetController,
    );
  }

  @override
  State<FinanceDateRangeSelector> createState() => _FinanceDateRangeSelectorState();
}

class _FinanceDateRangeSelectorState extends State<FinanceDateRangeSelector> {
  late FinanceDateRangePresenter dateFilters;

  @override
  void initState() {
    dateFilters = widget.initialDateFilters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.0, right: 18, left: 18, top: 18),
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
        border: Border.all(color: Colors.transparent),
      ),
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
                    "By Date",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.centerSheetController.close(result: dateFilters.dateRange);
                  },
                  child: Text(
                    "Apply",
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
            ...(FinanceSelectableDateRangeOptions.values.where((it) => it != FinanceSelectableDateRangeOptions.custom))
                .map(
                  (selectableOption) => GestureDetector(
                    onTap: () {
                      dateFilters.onSelectDateRangeOption(selectableOption);
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textFieldBackgroundColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectableOption.toSelectableString(),
                            style: TextStyles.subTitleTextStyleBold.copyWith(
                              color: _getAppropriateColor(selectableOption),
                            ),
                          ),
                          Icon(
                            Icons.radio_button_checked_outlined,
                            color: _getAppropriateColor(selectableOption),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => openCustomDateRangeSelector(context),
              child: Text(
                "Custom Range",
                style: TextStyles.titleTextStyle.copyWith(
                  color: AppColors.defaultColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openCustomDateRangeSelector(BuildContext context) async {
    var res = await CustomDateRangeSelector.show(context, dateFilters: dateFilters);
    if (res != null) {
      setState(() {});
      widget.centerSheetController.close(result: dateFilters.dateRange);
    }
  }

  Color _getAppropriateColor(FinanceSelectableDateRangeOptions selectableDateRangeOptions) {
    if (dateFilters.dateRange.selectedRangeOption == selectableDateRangeOptions) {
      return AppColors.defaultColor;
    } else {
      return AppColors.textColorDarkGray;
    }
  }
}
