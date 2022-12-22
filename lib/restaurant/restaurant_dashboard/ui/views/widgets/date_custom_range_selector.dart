import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../_common_widgets/screen_presenter/center_sheet_presenter.dart';
class DateCustomRangeSelector extends StatefulWidget {
  final CenterSheetController centerSheetController;
  const DateCustomRangeSelector({required this.centerSheetController, Key? key}) : super(key: key);

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false,}) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content:
      DateCustomRangeSelector(centerSheetController: centerSheetController),
      controller: centerSheetController,
    );
  }

  @override
  State<DateCustomRangeSelector> createState() => _DateCustomRangeSelectorState();
}

class _DateCustomRangeSelectorState extends State<DateCustomRangeSelector> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  late String _startDate, _endDate;
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    final DateTime today = DateTime.now();
    _startDate = DateFormat('dd, MMMM yyyy').format(today).toString();
    _endDate = DateFormat('dd, MMMM yyyy')
        .format(today.add(Duration(days: 3)))
        .toString();
    _controller.selectedRange = PickerDateRange(today, today.add(Duration(days: 3)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 50, child: Text('StartRangeDate:' '$_startDate')),
        Container(height: 50, child: Text('EndRangeDate:' '$_endDate')),
        Card(
          margin: const EdgeInsets.fromLTRB(50, 40, 50, 100),
          child: SfDateRangePicker(
            controller: _controller,
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: selectionChanged,
            allowViewNavigation: false,
          ),
        )
      ],
    );
       // Container(
       //    child: SfDateRangePicker(
       //      onSelectionChanged: _onSelectionChanged,
       //      selectionMode: DateRangePickerSelectionMode.range,
       //    ),
       //  );

  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('dd, MMMM yyyy').format(args.value.startDate).toString();
      _endDate =
          DateFormat('dd, MMMM yyyy').format(args.value.endDate ?? args.value.startDate).toString();
    });
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   print(args.value.);
  // }
  // @override
  // Widget build(BuildContext context) {
  //   final start = dateRange.start;
  //   final end = dateRange.end;
  //   return Column(children: [
  //     const Text(
  //       'Date Range',
  //       style: TextStyle(fontSize: 16),
  //     ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           child: ElevatedButton(
  //             child: Text(
  //               '${start.year}/${start.month}/${start.day}',
  //             ),
  //             onPressed: pickDateRange,
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(left: 20),
  //           child: ElevatedButton(
  //             child: Text(
  //               '${end.year}/${end.month}/${end.day}',
  //             ),
  //             onPressed: pickDateRange,
  //           ),
  //         ),
  //       ],
  //     )
  //   ]);
  // }

  Future pickDateRange() async {

  await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 2),
        lastDate: DateTime(DateTime.now().year + 2),
        initialDateRange: DateTimeRange(
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
          start: DateTime.now(),
        ),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              )
            ],
          );
        });
   // print(picked);

  }
  }

