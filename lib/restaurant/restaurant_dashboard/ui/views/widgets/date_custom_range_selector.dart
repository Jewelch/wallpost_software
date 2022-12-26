import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../_common_widgets/screen_presenter/center_sheet_presenter.dart';
import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';

class DateCustomRangeSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;

  const DateCustomRangeSelector({required this.centerSheetController, Key? key}) : super(key: key);

  static Future<dynamic> show(
    BuildContext context, {
    bool allowMultiple = false,
  }) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content: DateCustomRangeSelector(centerSheetController: centerSheetController),
      controller: centerSheetController,
    );
  }

  @override
  State<DateCustomRangeSelector> createState() => _DateCustomRangeSelectorState();
}

class _DateCustomRangeSelectorState extends State<DateCustomRangeSelector> {
  // DateTimeRange dateRange = DateTimeRange(
  //   start: DateTime(2021, 11, 5),
  //   end: DateTime(2022, 12, 10),
  // );
  late String _startDate, _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    final DateTime today = DateTime.now();
    _startDate = DateFormat('dd MMM').format(today).toString();
    _endDate = DateFormat('dd MMM').format(today.add(Duration(days: 3))).toString();
    _controller.selectedRange = PickerDateRange(today, today.add(Duration(days: 3)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text(
                  "Cancel",
                  style: TextStyles.titleTextStyle.copyWith(
                    color: AppColors.defaultColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: null,
                child: Text(
                  "Custom Range",
                  style: TextStyles.titleTextStyle.copyWith(
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //widget.centerSheetController.close();
                },
                child: Text(
                  "Apply",
                  style: TextStyles.titleTextStyle.copyWith(
                    color: AppColors.defaultColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              children: [
                Text('$_startDate', style: TextStyles.largeTitleTextStyleBold),
                Text(" - ", style: TextStyles.largeTitleTextStyleBold),
                Text('$_endDate', style: TextStyles.largeTitleTextStyleBold)
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SfDateRangePicker(
              controller: _controller,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: selectionChanged,
              allowViewNavigation: false,
            ),
          )
        ],
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate = DateFormat('dd MMM').format(args.value.startDate).toString();
      _endDate = DateFormat('dd MMM').format(args.value.endDate ?? args.value.startDate).toString();
    });
  }
}
