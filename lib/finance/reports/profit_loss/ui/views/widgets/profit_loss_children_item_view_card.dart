import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../entities/profit_loss_model.dart';

class ProfitsLossesChildrenCard extends StatelessWidget {
  final ProfitLossItem profitLossItem;
  List<ProfitLossItem> get profitLossItems => profitLossItem.children;
  final bool isColored;

  const ProfitsLossesChildrenCard(
    this.profitLossItem, {
    required this.isColored,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(profitLossItems.length);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      borderOnForeground: true,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(top: 6),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: profitLossItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  trailing: profitLossItems[index].children.isEmpty ? SizedBox() : null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          profitLossItems[index].name,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textColorBlueGrayLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            profitLossItems[index].amount,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.largeTitleTextStyleBold.copyWith(
                                color: isColored
                                    ? (profitLossItems[index].formattedAmount >= 0
                                        ? profitLossItems[index].formattedAmount > 0
                                            ? AppColors.brightGreen
                                            : AppColors.textColorBlack
                                        : AppColors.red)
                                    : AppColors.textColorBlack),
                          ),
                          SizedBox(width: 3),
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
                  children: profitLossItems[index].children.isEmpty
                      ? []
                      : [
                          ProfitsLossesChildrenCard(profitLossItems[index], isColored: isColored),
                          // index < profitLossItems.length - 1
                          //     ? Divider(
                          //         thickness: 1.5,
                          //         height: 1,
                          //         color: AppColors.appBarShadowColor,
                          //       )
                          //     : SizedBox.shrink(),
                        ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
