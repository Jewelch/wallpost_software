import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../../_shared/constants/app_years.dart';

class FinanceFilters extends StatefulWidget {
  final _years = AppYears().years().reversed.toList();

  final FinanceDashboardPresenter presenter;
  final ModalSheetController modalSheetController;
  late final int _initialMonth;
  late final int _initialYear;

  FinanceFilters(
      {required initialMonth, required initialYear, required this.modalSheetController, required this.presenter}) {
    this._initialMonth = _isMonthValidForYear(initialMonth-1, initialYear) ? initialMonth - 1 : -1;
    this._initialYear = _years.contains(initialYear) ? initialYear : _years.last;
  }

  static Future<dynamic> show(BuildContext context,
      {bool allowMultiple = false,
      required FinanceDashboardPresenter financePresenter,
      required initialMonth,
      required initialYear}) {
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
  State<FinanceFilters> createState() => _FinanceFiltersState(_initialMonth, _initialYear);
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
                  onPressed: () =>
                  {
                    _selectedMonth=-1,
                    widget.modalSheetController.close(),
                    widget.presenter.setFilter(month: _selectedMonth + 1,
                        year: AppYears().getCurrentYear())

                  },
                  child: Text(
                    "Reset"
                    "",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16,),
            if(widget.presenter.getMonthCountForTheSelectedYear(_selectedYear)>5)
            _moreMonthButton(),
            SizedBox(height: 40),
            _applyChangesButton()
          ],
        ),
      ),
    );
  }

  Widget getYearList(BuildContext context) {
    return SizedBox(
      height: 150,
      child: new GridView.count(
        padding: EdgeInsets.only(top: 12),
        childAspectRatio: (1 / .4),
        crossAxisCount: 3,
        children: new List<Widget>.generate(widget._years.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: getSingleYearItem(index),
          );
        }),
      ),
    );
  }

  Widget getSingleYearItem(int index) {
    return CustomFilterChip(
        backgroundColor: (widget._years[index] == _selectedYear) ? AppColors.defaultColor : Colors.transparent,
        borderColor: Colors.transparent,
        title: Text(
          widget._years[index].toString(),
          style: TextStyle(
            color: (widget._years[index] == _selectedYear) ? Colors.white : AppColors.textColorGray,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {_selectedYear = widget._years[index], setState(() {})});
  }

  Widget getMonthList(BuildContext context) {
    return SizedBox(
      height: showMoreMonth?170:100,
      child: new GridView.count(
        padding: EdgeInsets.only(top: 12),
        childAspectRatio: (1 / .4),
        crossAxisCount: 3,
        children: new List<Widget>.generate(widget.presenter.getMonthCountForTheSelectedYear(_selectedYear), (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
          widget.presenter.getMonthNamesForSelectedYear(_selectedYear)[index],
          style: TextStyle(
            color: (index == _selectedMonth) ? Colors.white : AppColors.textColorGray,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {_selectedMonth = index, setState(() {})});
  }

  Widget _applyChangesButton() {
    return GestureDetector(
      onTap: () => {
        widget.modalSheetController.close(),
        widget.presenter.setFilter(month: _selectedMonth + 1, year:_selectedYear)
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            ),
        child: Center(
          child: Text(
            'Apply Changes',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }



  bool showMoreMonth=false;
  _moreMonthButton() {
    return GestureDetector(
      onTap: () {
          if (showMoreMonth) {
            showMoreMonth = false;
          } else
            showMoreMonth = true;
          setState(() {

        });
      },
        child: Container(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showMoreMonth ? 'Less Months' : 'More Month',
              style: TextStyle(color: AppColors.defaultColor),),
            SizedBox(width: 4,),
            Container(
              height: 8,width: 8,
                child: Center(child: SvgPicture.asset('assets/icons/arrow_down_icon.svg', color: AppColors.defaultColor)),
                )
          ],
        ),));
  }

}
