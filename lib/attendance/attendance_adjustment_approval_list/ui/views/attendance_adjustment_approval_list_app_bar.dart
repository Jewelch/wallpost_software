import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class AttendanceAdjustmentApprovalListAppBar extends StatefulWidget {
  final int noOfSelectedItems;
  final bool isMultipleSelectionInProgress;
  final bool isAllItemAreSelected;
  final VoidCallback onInitiateMultipleSelectionButtonPressed;
  final VoidCallback onEndMultipleSelectionButtonPressed;
  final VoidCallback onSelectAllButtonPress;
  final VoidCallback onUnselectAllButtonPress;

  AttendanceAdjustmentApprovalListAppBar({
    required this.noOfSelectedItems,
    required this.isMultipleSelectionInProgress,
    required this.onInitiateMultipleSelectionButtonPressed,
    required this.onEndMultipleSelectionButtonPressed,
    required this.onSelectAllButtonPress,
    required this.onUnselectAllButtonPress,
    required this.isAllItemAreSelected,
  });

  @override
  State<AttendanceAdjustmentApprovalListAppBar> createState() => _AttendanceAdjustmentApprovalListAppBarState();
}

class _AttendanceAdjustmentApprovalListAppBarState extends State<AttendanceAdjustmentApprovalListAppBar> {
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
                child: Text("Payroll Adjustment Approvals", style: TextStyles.largeTitleTextStyleBold)),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_back_icon.svg",
                    color: AppColors.defaultColor,
                    width: 16,
                    height: 16,
                  ),
                ),
                IconButton(
                  onPressed: widget.onInitiateMultipleSelectionButtonPressed,
                  icon: Icon(
                    Icons.check_box_outlined,
                    size: 22,
                    color: AppColors.defaultColor,
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 16),
                child: Text("Payroll Adjustment Approvals", style: TextStyles.largeTitleTextStyleBold)),
            SizedBox(height: 8)
          ],
        ),
      );
    }
  }
}
