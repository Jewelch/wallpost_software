import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SingleDateSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;
  final DateTime initialDate;

  const SingleDateSelector({required this.centerSheetController, required this.initialDate, Key? key})
      : super(key: key);

  static Future<dynamic> show(
    BuildContext context, {
    required DateTime initialDate,
  }) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content: SingleDateSelector(
        centerSheetController: centerSheetController,
        initialDate: initialDate,
      ),
      controller: centerSheetController,
    );
  }

  @override
  State<SingleDateSelector> createState() => _SingleDateSelectorState();
}

class _SingleDateSelectorState extends State<SingleDateSelector> {
  late DateTime _selectedDate;
  late String selectedDateString;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    _selectedDate = widget.initialDate;
    selectedDateString = DateFormat('dd MMM').format(_selectedDate).toString();
    _controller.selectedDate = _selectedDate;
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
                  "Custom Date",
                  style: TextStyles.titleTextStyle.copyWith(
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.centerSheetController.close(result: _controller.selectedDate!);
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
                Text(DateFormat('dd MMM').format(_controller.selectedDate!).toString(),
                    style: TextStyles.largeTitleTextStyleBold),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SfDateRangePicker(
              controller: _controller,
              selectionMode: DateRangePickerSelectionMode.single,
              allowViewNavigation: false,
              onSelectionChanged: (_) {
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}
