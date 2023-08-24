import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenters/receivables_and_ageing_presenter.dart';

class ReceivablesList extends StatelessWidget {
  const ReceivablesList(
    this.presenter, {
    super.key,
  });

  final ReceivablesPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.screenBackgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Days",
                  style: TextStyles.headerCardMoneyLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorBlack,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Due",
                  style: TextStyles.headerCardMoneyLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorBlack,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Overdue",
                  style: TextStyles.headerCardMoneyLabelTextStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.screenBackgroundColor, 
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: presenter.receivablesReport.items
                    .map((item) => Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.period,
                                    style: TextStyles.titleTextStyleBold,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  item.due,
                                  style: TextStyles.titleTextStyleBold,
                                )),
                                Expanded(
                                    child: Text(
                                  item.overdue,
                                  style: TextStyles.titleTextStyleBold
                                      .copyWith(color: presenter.getOverDueTextColor(item.overdue)),
                                )),
                              ],
                            ),
                            SizedBox(height: 8),
                            Divider(),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ))
                    .toList()),
          ),
        ),
      ],
    );
  }
}
