import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../../_shared/constants/app_years.dart';

class FinanceFilters extends StatefulWidget {
  final _years = AppYears().years();

  final FinanceDashboardPresenter presenter;
  final ModalSheetController modalSheetController;
  late final int _initialMonth;
  late final int _initialYear;
  //FinanceFilters({required this.modalSheetController, required this.presenter});

  FinanceFilters({required initialMonth, required initialYear, required this.modalSheetController, required this.presenter}) {
    this._initialMonth = _isMonthValidForYear(initialMonth, initialYear) ? initialMonth-1 : -1;
    this._initialYear = _years.contains(initialYear) ? _years.indexOf(initialYear) : 0;
  }

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false, required FinanceDashboardPresenter financePresenter,required initialMonth, required initialYear}) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: FinanceFilters(
        initialMonth: initialMonth,
        initialYear: initialYear,
        modalSheetController: modalSheetController,
        presenter: financePresenter,
      ),
      controller: modalSheetController,
      isCurveApplied: false,
    );
  }
  bool _isMonthValidForYear(int month, int year) {
    if (month < AppYears().currentAndPastMonthsOfYear(year).length) return true;

    return false;
  }
  @override
  State<FinanceFilters> createState() => _FinanceFiltersState(_initialMonth,_initialYear);
}

class _FinanceFiltersState extends State<FinanceFilters> {

  int _selectedMonth;
  int _selectedYear;
  _FinanceFiltersState(initialMonth, int initialYear)
      : _selectedMonth = initialMonth,
        _selectedYear = initialYear;




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.0, right: 18, left: 18, top: 18),
      decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.transparent)),
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
                    "Filters",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => [
                    widget.modalSheetController.close(),
                    widget.presenter.setFilter(month: _selectedMonth+1, year: AppYears().years()[_selectedYear])
                  ],
                  child: Text(
                    "Apply"
                    "",
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
              "Year",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(child: getYearList(context)),
            Text(
              "Months",
              style: TextStyles.screenTitleTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(child: getMonthList(context)),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }



  Widget getYearList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: new GridView.count(
        childAspectRatio: (1 / .4),
        crossAxisCount: 3,
        children: new List<Widget>.generate(8, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            /* child: Container(
              color: AppColors.defaultColor,
                child: (Text(youList[index]))),*/
            child: getSingleYearItem(index),
          );
        }),
      ),
    );
  }

  Widget getSingleYearItem(int index) {
    return CustomFilterChip(
        backgroundColor: (index == _selectedYear) ? AppColors.defaultColor : Colors.transparent,
        borderColor: Colors.transparent,
        title: Text(
          widget._years[index].toString(),
          style: TextStyle(
            color: (index == _selectedYear) ? Colors.white : AppColors.textColorGray,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {
          _selectedYear = index,
              /* widget._presenter.selectModuleAtIndex(index),
          widget.onPressed.call(),*/
              setState(() {})
            });
  }

/*
  List<String> monthList=['Jan','Feb','Mar','Apr','May','Jun',
    'July','Aug','Sep','Oct','Nov','Dec'];*/
  Widget getMonthList(BuildContext context) {
    return SizedBox(
      height: 200,
      child: new GridView.count(
        childAspectRatio: (1 / .4),
        crossAxisCount: 3,
        children: new List<Widget>.generate(12, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            /* child: Container(
              color: AppColors.defaultColor,
                child: (Text(youList[index]))),*/
            child: getSingleMonthItem(index),
          );
        }),
      ),
    );
  }

  Widget getSingleMonthItem(int index) {
    return CustomFilterChip(
        backgroundColor: (index == _selectedMonth) ? AppColors.defaultColor : Colors.transparent,
        borderColor: Colors.transparent,
        title: Text(
          _getMonthNamesForSelectedYear()[index],
          style: TextStyle(
            color: (index == _selectedMonth) ? Colors.white : AppColors.textColorGray,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {
          _selectedMonth = index,
              /* widget._presenter.selectModuleAtIndex(index),
          widget.onPressed.call(),*/
              setState(() {})
            });
  }

  List<String> _getMonthNamesForSelectedYear() {
    var years = AppYears().currentAndPastShortenedMonthsOfYear(widget._years.last);
    return years;
  }



}
