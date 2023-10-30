import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../presenter/stock_expiration_presenter.dart';

class StocksExpirationList extends StatelessWidget {
  final StocksExpirationPresenter presenter;
  StocksExpirationList(this.presenter);

  @override
  Widget build(BuildContext context) {
    return presenter.stocksExpiration.isEmpty
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              borderOnForeground: true,
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Items",
                            style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Qty.",
                            style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Expired on​",
                            style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: 8),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: presenter.stocksExpiration.length,
                    itemBuilder: (context, index) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  presenter.stocksExpiration[index].name,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.textColorBlueGray,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  presenter.stocksExpiration[index].stock,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: presenter.isDatePositive(presenter.stocksExpiration[index].expireDate)
                                        ? AppColors.brightGreen
                                        : AppColors.lightGray2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  presenter.stocksExpiration[index].expireDate,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.subTitleTextStyle.copyWith(
                                    color: presenter.isDatePositive(presenter.stocksExpiration[index].expireDate)
                                        ? AppColors.lightGray2
                                        : AppColors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index != presenter.stocksExpiration.length - 1) Divider(height: 1)
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
  }
}
