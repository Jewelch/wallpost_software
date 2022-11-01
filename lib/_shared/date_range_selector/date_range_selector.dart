import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import 'date_range_filters.dart';

enum CustomDateRangeSegments { from, to }

class DateRangeSelector extends StatefulWidget {
  final ModalSheetController modalSheetController;
  final DateRangeFilters? initialDateRangeFilters;

  DateRangeSelector._(this.modalSheetController, [this.initialDateRangeFilters]);

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false,
      required Function(DateRangeFilters) onDateRangeFilterSelected,
      DateRangeFilters? initialDateRangeFilter}) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: DateRangeSelector._(modalSheetController, initialDateRangeFilter),
      controller: modalSheetController,
    );
  }

  @override
  State<DateRangeSelector> createState() => _State(initialDateRangeFilters);
}

class _State extends State<DateRangeSelector> {
  late DateRangeFilters dateFilters;

  _State([DateRangeFilters? initialDateFilters]) {
    dateFilters = initialDateFilters ?? DateRangeFilters();
  }

  CustomDateRangeSegments _selectedSegment = CustomDateRangeSegments.from;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: SelectableDateRangeOptions.values
                    .map(
                      (dateOption) => CustomFilterChip(
                        shape: CustomFilterChipShape.roundedRectangle,
                        backgroundColor: AppColors.filtersBackgroundColor,
                        borderColor: dateFilters.selectedRangeOption != dateOption
                            ? AppColors.filtersBackgroundColor
                            : AppColors.defaultColorDark,
                        title: Text(dateOption.toReadableString(), style: TextStyle(color: AppColors.defaultColorDark)),
                        onPressed: () {
                          if (dateOption == SelectableDateRangeOptions.thisMonth) {
                            dateFilters.selectedRangeOption = dateOption;
                            var today = DateTime.now();
                            var startDate = today.subtract(Duration(days: 31));
                            dateFilters.startDate = startDate;
                            dateFilters.endDate = today;
                          } else {
                            dateFilters.selectedRangeOption = dateOption;
                          }
                          setState(() {});
                        },
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Visibility(
                  visible: dateFilters.selectedRangeOption == SelectableDateRangeOptions.custom,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<CustomDateRangeSegments>(
                          padding: EdgeInsets.all(1),
                          backgroundColor: AppColors.tabDatePickerColor,
                          groupValue: _selectedSegment,
                          onValueChanged: (CustomDateRangeSegments? value) {
                            if (value != null) {
                              setState(() {
                                _selectedSegment = value;
                              });
                            }
                          },
                          children: const <CustomDateRangeSegments, Widget>{
                            CustomDateRangeSegments.from: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'From',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            CustomDateRangeSegments.to: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'To',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 8),
                        child: Row(
                          children: [
                            Spacer(),
                            SizedBox(
                              width: 100,
                              child: Text(
                                dateFilters.startDate.yMMMd().toUpperCase(),
                                style: TextStyle(color: AppColors.textColorGray, fontSize: 14),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 100,
                              child: Text(
                                dateFilters.endDate.yMMMd().toUpperCase(),
                                style: TextStyle(color: AppColors.textColorGray, fontSize: 14),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).copyWith().size.height * 0.25,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(fontSize: 14),
                              pickerTextStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (value) {
                              setState(() {
                                _selectedSegment == CustomDateRangeSegments.from
                                    ? dateFilters.startDate = value
                                    : dateFilters.endDate = value;
                              });
                            },
                            initialDateTime: DateTime.now(),
                            minimumDate: DateTime.utc(2010),
                            maximumDate: DateTime.now(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: RoundedRectangleActionButton(
                      title: 'Apply',
                      onPressed: () {
                        widget.modalSheetController.close(result: dateFilters);
                      },
                      backgroundColor: AppColors.green,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: RoundedRectangleActionButton(
                      title: 'Clear',
                      onPressed: () {
                        setState(() {
                          _selectedSegment = CustomDateRangeSegments.from;
                        });
                      },
                      backgroundColor: AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
