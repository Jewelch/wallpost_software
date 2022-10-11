import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

import '../../entities/filtering_value.dart';

enum DateLimits { from, to }

class DateFilteringBottomSheet extends StatefulWidget {
  DateFilteringBottomSheet({
    super.key,
    required List<String> elements,
    required this.onFilterSettled,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
  }) : filteringElements = elements..add('Custom');

  final List<String> filteringElements;
  final void Function(FilteringValue) onFilterSettled;

  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  @override
  State<DateFilteringBottomSheet> createState() => _State();
}

class _State extends State<DateFilteringBottomSheet> {
  DateLimits _selectedSegment = DateLimits.from;
  int? _selectedFilterIndex;
  DateTime? _startDate;
  DateTime? _endDate;

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
                children: widget.filteringElements
                    .map(
                      (title) => CustomFilterChip(
                        shape: CustomFilterChipShape.roundedRectangle,
                        backgroundColor: AppColors.filtersBackgroundColor,
                        borderColor: _selectedFilterIndex == null
                            ? AppColors.filtersBackgroundColor
                            : title == widget.filteringElements[_selectedFilterIndex!]
                                ? AppColors.defaultColorDark
                                : AppColors.filtersBackgroundColor,
                        title: Text(title, style: TextStyle(color: AppColors.defaultColorDark)),
                        onPressed: () => setState(() => _selectedFilterIndex = widget.filteringElements.toList().indexOf(title)),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Visibility(
                  visible: _selectedFilterIndex == widget.filteringElements.length - 1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<DateLimits>(
                          padding: EdgeInsets.all(1),
                          backgroundColor: AppColors.tabDatePickerColor,
                          groupValue: _selectedSegment,
                          onValueChanged: (DateLimits? value) {
                            if (value != null) {
                              setState(() {
                                _selectedSegment = value;
                              });
                            }
                          },
                          children: const <DateLimits, Widget>{
                            DateLimits.from: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'From',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DateLimits.to: Padding(
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
                                _startDate?.yMMMd().toUpperCase() ?? '',
                                style: TextStyle(color: AppColors.textColorGray, fontSize: 14),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 100,
                              child: Text(
                                _endDate?.yMMMd().toUpperCase() ?? '',
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
                                _selectedSegment == DateLimits.from ? _startDate = value : _endDate = value;
                              });
                            },
                            initialDateTime: _endDate ?? _startDate ?? widget.initialDateTime ?? DateTime.now(),
                            minimumDate: _selectedSegment == DateLimits.from
                                ? widget.minimumDate ?? DateTime.utc(1950)
                                : (_startDate ?? widget.minimumDate ?? DateTime.utc(1950)),
                            maximumDate: _selectedSegment == DateLimits.to
                                ? widget.maximumDate ?? DateTime.now()
                                : (_endDate ?? widget.maximumDate ?? DateTime.now()),
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
                        if (_selectedFilterIndex != null && _selectedFilterIndex != widget.filteringElements.length - 1) {
                          _startDate = null;
                          _endDate = null;
                        }
                        widget.onFilterSettled(FilteringValue(
                          filteringElement: widget.filteringElements[_selectedFilterIndex ?? 0],
                          startDate: _startDate?.yyyyMMddString(),
                          endDate: _endDate?.yyyyMMddString(),
                        ));
                        Navigator.of(context).pop();
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
                          _selectedSegment = DateLimits.from;
                          _selectedFilterIndex = null;
                          _startDate = null;
                          _endDate = null;
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
