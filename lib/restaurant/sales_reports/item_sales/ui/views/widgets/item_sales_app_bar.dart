import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/item_sales_presenter.dart';

class ItemSalesAppBar extends StatelessWidget {
  final ItemSalesPresenter presenter;
  final bool displayBackground;

  ItemSalesAppBar(this.presenter, this.displayBackground);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Visibility(
          visible: displayBackground,
          child: Container(width: 400, height: 20, color: Colors.white),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.screenBackgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(color: AppColors.appBarShadowColor, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(width: 12),
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
                        SvgPicture.asset(
                          "assets/icons/implifier_icon.svg",
                          color: AppColors.defaultColor,
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 14),
                      ],
                    ),
                    Text(
                      "Sales/Report/Sales",
                      style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Item Sales",
                      style: TextStyles.extraLargeTitleTextStyleBold
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 52,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: GestureDetector(
                            onTap: () {
                              presenter.onFiltersGotClicked();
                            },
                            child: SvgPicture.asset(
                              "assets/icons/filter_date_icon.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 25),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return _FiltringItem(
                            onFilterGotClicked: () {},
                            filteringType: presenter.getFilterType(index));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _FiltringItem extends StatelessWidget {
  VoidCallback onFilterGotClicked;
  String filteringType;

  _FiltringItem({
    required this.onFilterGotClicked,
    required this.filteringType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onFilterGotClicked,
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
                    color: AppColors.cancelButton,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      "assets/icons/cancel_icon.svg",
                      height: 9.3,
                      width: 9.3,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
