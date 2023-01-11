import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/item_sales_presenter.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
    this.presenter, {
    super.key,
  });

  static final appbarNotifier = ItemNotifier<bool>(defaultValue: false);
  final ItemSalesPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 150);

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
  final ItemSalesPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 0);

  @override
  Widget build(BuildContext context) => ItemSalesAppBar(presenter, displayBackground);
}

class ItemSalesAppBar extends StatelessWidget {
  final ItemSalesPresenter presenter;
  final bool displayBackground;

  const ItemSalesAppBar(
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
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: SvgPicture.asset(
                            "assets/icons/arrow_back_icon.svg",
                            color: AppColors.defaultColor,
                            width: 16,
                            height: 16,
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: GestureDetector(
                            onTap: Navigator.of(context).pop,
                            child: Container(
                              height: 40,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        presenter.getSelectedCompanyName(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyles.largeTitleTextStyleBold.copyWith(
                                          color: AppColors.defaultColor,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SvgPicture.asset(
                                      "assets/icons/arrow_down_icon.svg",
                                      color: AppColors.defaultColor,
                                      width: 16,
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        // uncomment to show the right icon
                        // SvgPicture.asset(
                        //   "assets/icons/implifier_icon.svg",
                        //   color: AppColors.defaultColor,
                        //   width: 16,
                        //   height: 16,
                        // ),
                        SizedBox(width: 14),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sales/Report/Sales",
                            style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Item Sales",
                            style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
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
                                  "assets/icons/filter_date_icon.svg",
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
                                    (filterString) => _FiltringItem(presenter: presenter, filteringType: filterString),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FiltringItem extends StatelessWidget {
  final ItemSalesPresenter presenter;
  final String filteringType;

  const _FiltringItem({
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
