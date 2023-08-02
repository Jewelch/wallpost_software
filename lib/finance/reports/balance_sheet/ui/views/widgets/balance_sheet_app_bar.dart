import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/company_name_app_bar.dart';
import 'package:wallpost/finance/reports/balance_sheet/ui/presenters/balance_sheet_presenter.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';

class BalanceSheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  BalanceSheetAppBar(
    this.presenter, {
    super.key,
  });

  static final appbarNotifier = ItemNotifier<bool>(defaultValue: false);
  final BalanceSheetPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 152);

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<bool>(
      notifier: appbarNotifier,
      builder: (context, displayBackground) => AppBar(
        elevation: 0,
        backgroundColor: AppColors.screenBackgroundColor,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        bottom: _AppBarWidget(presenter, displayBackground),
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  _AppBarWidget(this.presenter, this.displayBackground);

  final bool displayBackground;
  final BalanceSheetPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 0);

  @override
  Widget build(BuildContext context) => ProfitsLossesAppBar(presenter, displayBackground);
}

class ProfitsLossesAppBar extends StatelessWidget {
  final BalanceSheetPresenter presenter;
  final bool displayBackground;

  const ProfitsLossesAppBar(
    this.presenter,
    this.displayBackground, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 400,
          height: 50,
          color: displayBackground ? AppColors.screenBackgroundColor : AppColors.screenBackgroundColor2,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.screenBackgroundColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: AppColors.appBarShadowColor, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyNameAppBar(presenter.getSelectedCompanyName()),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Finance/Reports",
                      style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Balance Sheet",
                      style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(width: 20),
                  SizedBox(
                    height: 52,
                    width: 40,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            presenter.onFiltersGotClicked();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/filter_icon.svg",
                            width: 18,
                            height: 18,
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: presenter.filters
                            .toReadableListOfString()
                            .map(
                              (filterString) => _FilterItem(presenter: presenter, filteringType: filterString),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterItem extends StatelessWidget {
  final BalanceSheetPresenter presenter;
  final String filteringType;

  const _FilterItem({
    required this.presenter,
    required this.filteringType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          GestureDetector(
            onTap: presenter.onFiltersGotClicked,
            child: Container(
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Row(
                children: [
                  Text(
                    filteringType, //  presenter.dateFilters.selectedRangeOption.toReadableString(),
                    style: TextStyles.labelTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 16,
                    width: 16,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.defaultColorDarkContrastColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GestureDetector(
                      child: SvgPicture.asset(
                        "assets/icons/cancel_icon.svg",
                        height: 9.3,
                        width: 9.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
