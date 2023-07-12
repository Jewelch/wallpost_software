import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../../entities/profit_loss_model.dart';

class ProfitsLossesChildrenCard extends StatelessWidget {
  final ProfitLossItem profitLossItem;
  List<ProfitLossItem> get profitLossItems => profitLossItem.children;
  final bool isParent;

  const ProfitsLossesChildrenCard(
    this.profitLossItem, {
    required this.isParent,
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
      child: Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(top: 1),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profitLossItems.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isParent ? 14 : 0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isParent ? 14 : 0)),
                collapsedBackgroundColor: !isParent ? AppColors.screenBackgroundColor2 : Colors.white,
                backgroundColor: !isParent ? AppColors.screenBackgroundColor2 : Colors.white,
                childrenPadding: EdgeInsets.zero,
                tilePadding: EdgeInsets.only(left: 16, right: 8),
                trailing: profitLossItems[index].children.isEmpty ? SizedBox.shrink() : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        profitLossItems[index].name,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textColorBlueGray,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        profitLossItems[index].amount,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.largeTitleTextStyleBold.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                children: profitLossItems[index].children.isEmpty
                    ? []
                    : [
                        ProfitsLossesChildrenCard(profitLossItems[index], isParent: false),
                      ],
              );
            },
          ),
        ],
      ),
    );
  }
}
