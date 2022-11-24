import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';

class DateRangeSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;

  final DateRangeFilters initialDateFilters;

  DateRangeSelector({required this.centerSheetController, required this.initialDateFilters, Key? key})
      : super(key: key);

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false,
      required Function(DateRangeFilters) onDateRangeFilterSelected,
      required DateRangeFilters initialDateRangeFilter}) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content:
          DateRangeSelector(centerSheetController: centerSheetController, initialDateFilters: initialDateRangeFilter),
      controller: centerSheetController,
    );
  }

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late DateRangeFilters dateFilters;

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
                    widget.centerSheetController.close(result: dateFilters);
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
            ...(SelectableDateRangeOptions.values.where((it) => it != SelectableDateRangeOptions.custom))
                .map(
                  (selectableOption) => GestureDetector(
                    onTap: () {
                      dateFilters.setSelectedDateRangeOption(selectableOption);
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textFieldBackgroundColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectableOption.toReadableString(),
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
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Color _getAppropriateColor(SelectableDateRangeOptions selectableDateRangeOptions) {
    if (dateFilters.selectedRangeOption == selectableDateRangeOptions) {
      return AppColors.defaultColor;
    } else {
      return AppColors.textColorDarkGray;
    }
  }
}
