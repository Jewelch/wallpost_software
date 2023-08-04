import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../entities/selectable_date_range_option.dart';
import '../presenters/date_range_presenter.dart';

class CustomDateRangeSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;
  final FinanceDateRangePresenter presenter;

  const CustomDateRangeSelector({required this.centerSheetController, required this.presenter, Key? key})
      : super(key: key);

  static Future<dynamic> show(
    BuildContext context, {
    required FinanceDateRangePresenter dateFilters,
  }) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content: CustomDateRangeSelector(
        centerSheetController: centerSheetController,
        presenter: dateFilters,
      ),
      controller: centerSheetController,
    );
  }

  @override
  State<CustomDateRangeSelector> createState() => _CustomDateRangeSelectorState();
}

class _CustomDateRangeSelectorState extends State<CustomDateRangeSelector> {
  late DateTime _startDate, _endDate;
  late String startDate, endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    _endDate = widget.presenter.dateRange.endDate;
    _startDate = widget.presenter.dateRange.startDate;
    startDate = DateFormat('dd MMM').format(_startDate).toString();
    endDate = DateFormat('dd MMM').format(_endDate).toString();
    _controller.selectedRange = PickerDateRange(_startDate, _endDate);
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
                  widget.presenter.onSelectDateRangeOption(FinanceSelectableDateRangeOptions.custom,
                      customStartDate: _startDate, customEndDate: _endDate);
                  widget.centerSheetController.close(result: widget.presenter);
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
                Text('$startDate', style: TextStyles.largeTitleTextStyleBold),
                Text(" - ", style: TextStyles.largeTitleTextStyleBold),
                Text('$endDate', style: TextStyles.largeTitleTextStyleBold)
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
      _startDate = args.value.startDate;
      startDate = DateFormat('dd MMM').format(_startDate).toString();
      _endDate = args.value.endDate ?? args.value.startDate;
      endDate = DateFormat('dd MMM').format(_endDate).toString();
    });
  }
}
