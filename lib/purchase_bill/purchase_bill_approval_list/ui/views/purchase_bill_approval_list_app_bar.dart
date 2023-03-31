import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../_common_widgets/buttons/rounded_back_button.dart';

class PurchaseBillApprovalListAppBar extends StatefulWidget {
  final String selectedCompanyName;
  final int noOfSelectedItems;
  final bool isMultipleSelectionInProgress;
  final bool isAllItemAreSelected;
  final VoidCallback onInitiateMultipleSelectionButtonPressed;
  final VoidCallback onEndMultipleSelectionButtonPressed;
  final VoidCallback onSelectAllButtonPress;
  final VoidCallback onUnselectAllButtonPress;
  final VoidCallback onBackButtonPress;

  PurchaseBillApprovalListAppBar({
    required this.selectedCompanyName,
    required this.noOfSelectedItems,
    required this.isMultipleSelectionInProgress,
    required this.onInitiateMultipleSelectionButtonPressed,
    required this.onEndMultipleSelectionButtonPressed,
    required this.onSelectAllButtonPress,
    required this.onUnselectAllButtonPress,
    required this.isAllItemAreSelected,
    required this.onBackButtonPress,
  });

  @override
  State<PurchaseBillApprovalListAppBar> createState() => _PurchaseBillApprovalListAppBarState();
}

class _PurchaseBillApprovalListAppBarState extends State<PurchaseBillApprovalListAppBar> {
  bool pressON = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isMultipleSelectionInProgress) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: widget.onEndMultipleSelectionButtonPressed, child: Text("Cancel")),
                if (widget.noOfSelectedItems > 0) Text("${widget.noOfSelectedItems} Selected"),
                widget.isAllItemAreSelected
                    ? TextButton(
                        onPressed: () {
                          widget.onUnselectAllButtonPress();
                        },
                        child: Text("Unselect All"))
                    : TextButton(
                        onPressed: () {
                          widget.onSelectAllButtonPress();
                        },
                        child: Text("Select All"))
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 16),
                child: Text("Purchase Bills", style: TextStyles.largeTitleTextStyleBold)),
            SizedBox(height: 8)
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedBackButton(
                  iconColor: AppColors.defaultColor,
                  backgroundColor: Colors.white,
                  onPressed: widget.onBackButtonPress,
                ),
                IconButton(
                  onPressed: widget.onInitiateMultipleSelectionButtonPressed,
                  icon: Icon(
                    Icons.check_box_outlined,
                    size: 22,
                    color: AppColors.defaultColor,
                  ),
                ),
                // SizedBox(width: 24),
                // Expanded(
                //   child: GestureDetector(
                //     onTap: Navigator.of(context).pop,
                //     child: Container(
                //       height: 40,
                //       child: Center(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Container(
                //               child: Text(
                //                 widget.selectedCompanyName,
                //                 overflow: TextOverflow.ellipsis,
                //                 textAlign: TextAlign.center,
                //                 style: TextStyles.largeTitleTextStyleBold
                //                     .copyWith(color: AppColors.defaultColor, fontWeight: FontWeight.w500),
                //               ),
                //             ),
                //             SizedBox(width: 8),
                //             SvgPicture.asset(
                //               "assets/icons/arrow_down_icon.svg",
                //               color: AppColors.defaultColor,
                //               width: 16,
                //               height: 16,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 16),
                child: Text("Purchase Bills", style: TextStyles.largeTitleTextStyleBold)),
            SizedBox(height: 8)
          ],
        ),
      );
    }
  }
}
