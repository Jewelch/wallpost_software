import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../presenters/finance_filter_presenter.dart';

class FinanceFilters extends StatefulWidget {
  late final FinanceFiltersPresenter financeFiltersPresenter;
  final FinanceDashboardPresenter dashboardPresenter;
  final ModalSheetController modalSheetController;

  FinanceFilters(
      {required initialMonth,
      required initialYear,
      required this.modalSheetController,
      required this.dashboardPresenter}) {
    financeFiltersPresenter = FinanceFiltersPresenter(initialMonth: initialMonth, initialYear: initialYear);
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
        dashboardPresenter: financePresenter,
      ),
      controller: modalSheetController,
      isCurveApplied: false,
    );
  }

  @override
  State<FinanceFilters> createState() => _FinanceFiltersState();
}

class _FinanceFiltersState extends State<FinanceFilters> {
  bool showMoreMonth = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24, right: 18, left: 18, top: 18),
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
                  onPressed: () => {
                    widget.modalSheetController.close(),
                    widget.dashboardPresenter.setFilter(month: 0, year: widget.financeFiltersPresenter.years.first)
                  },
                  child: Text(
                    "Reset",
                    style: TextStyles.screenTitleTextStyle.copyWith(color: AppColors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Year",
              style: TextStyles.screenTitleTextStyle
                  .copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500),
            ),
            Container(child: getYearList(context)),
            Text(
              "Months",
              style: TextStyles.screenTitleTextStyle
                  .copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500),
            ),
            Container(child: getMonthList(context)),
            SizedBox(
              height: 16,
            ),
            if (widget.financeFiltersPresenter.shouldShowMoreMonthButton()) _moreMonthButton(),
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
        children: new List<Widget>.generate(widget.financeFiltersPresenter.years.length, (index) {
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
        backgroundColor: widget.financeFiltersPresenter.getYearItemBackgroundColor(index),
        borderColor: Colors.transparent,
        title: Text(
          widget.financeFiltersPresenter.years[index].toString(),
          style: TextStyle(
            color: widget.financeFiltersPresenter.getYearItemTextColor(index),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {
              widget.financeFiltersPresenter.setFilterYear(widget.financeFiltersPresenter.years[index]),
              setState(() {})
            });
  }

  Widget getMonthList(BuildContext context) {
    return SizedBox(
      height: showMoreMonth ? 170 : 100,
      child: new GridView.count(
        padding: EdgeInsets.only(top: 12),
        childAspectRatio: (1 / .4),
        crossAxisCount: 3,
        children: new List<Widget>.generate(widget.financeFiltersPresenter.getMonthCountForTheSelectedYear(), (index) {
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
        backgroundColor: widget.financeFiltersPresenter.getMonthItemBackgroundColor(index),
        borderColor: Colors.transparent,
        title: Text(
          widget.financeFiltersPresenter.getMonthNamesForSelectedYear()[index],
          style: TextStyle(
            color: widget.financeFiltersPresenter.getMonthItemTextColor(index),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () => {widget.financeFiltersPresenter.setFilterMonth(index), setState(() {})});
  }

  Widget _applyChangesButton() {
    return GestureDetector(
      onTap: () => {
        widget.modalSheetController.close(),
        widget.dashboardPresenter.setFilter(
            month: widget.financeFiltersPresenter.selectedMonth + 1, year: widget.financeFiltersPresenter.selectedYear)
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
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  _moreMonthButton() {
    return GestureDetector(
        onTap: () {
          showMoreMonth ? showMoreMonth = false : showMoreMonth = true;
          setState(() {});
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showMoreMonth ? 'Less Months' : 'More Months',
                style: TextStyle(color: AppColors.defaultColor),
              ),
              SizedBox(width: 4),
              Container(
                height: 8,
                width: 8,
                child:
                    Center(child: SvgPicture.asset('assets/icons/arrow_down_icon.svg', color: AppColors.defaultColor)),
              )
            ],
          ),
        ));
  }
}
