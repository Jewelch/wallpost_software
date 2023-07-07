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
    final double itemNameWidth = MediaQuery.of(context).size.width * .32;
    return Padding(
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
                  SizedBox(width: itemNameWidth),
                  Spacer(),
                  Text(
                    "Revenue",
                    style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
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
                            color: AppColors.textColorBlueGray,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      // Spacer(),

                      Row(
                        children: [
                          SizedBox(width: 8),
                          Text(
                            profitLossItems[index].amount,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.largeTitleTextStyleBold.copyWith(
                                color: isColored
                                    ? (num.parse(profitLossItems[index].amount) >= 0
                                        ? num.parse(profitLossItems[index].amount) > 0
                                            ? Colors.green
                                            : Colors.black
                                        : Colors.red)
                                    : Colors.black),
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
                          index < profitLossItems.length - 1 ? Divider(height: 1) : SizedBox(),
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
