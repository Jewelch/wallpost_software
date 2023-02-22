import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/hourly_sales_presenter.dart';

class HourlySalesDataCard extends StatelessWidget {
  final HourlySalesPresenter presenter;

  const HourlySalesDataCard(
    this.presenter, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 6),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: presenter.getDataListLength(),
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      presenter.getHourAtIndex(index),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textColorBlueGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          presenter.getTicketsNumberAtIndex(index),
                          style: TextStyles.headerCardSubValueTextStyle.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            presenter.getTotalRevenueAtIndex(index),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headerCardSubValueTextStyle,
                          ),
                        ),
                        SizedBox(width: 2),
                        Column(
                          children: [
                            Text(
                              'QAR',
                              style: TextStyle(
                                color: AppColors.textColorBlueGray,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              index < presenter.getDataListLength() - 1 ? Divider(height: 1) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
