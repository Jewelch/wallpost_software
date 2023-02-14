import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

//TODO
class ExpenseApprovalListAppBar extends StatefulWidget {
  final bool isMultipleSelectionInProgress;
  final VoidCallback onInitiateMultipleSelectionButtonPressed;
  final VoidCallback onEndMultipleSelectionButtonPressed;
  final VoidCallback onSelectAllButtonPress;
  final VoidCallback onUnselectAllButtonPress;

  ExpenseApprovalListAppBar({
    required this.isMultipleSelectionInProgress,
    required this.onInitiateMultipleSelectionButtonPressed,
    required this.onEndMultipleSelectionButtonPressed,
    required this.onSelectAllButtonPress,
    required this.onUnselectAllButtonPress,
  });

  @override
  State<ExpenseApprovalListAppBar> createState() => _ExpenseApprovalListAppBarState();
}

class _ExpenseApprovalListAppBarState extends State<ExpenseApprovalListAppBar> {
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
                // if (_listPresenter.getSelectedExpenseCount() > 0)
                //   Text("${_listPresenter.getSelectedExpenseCount()} Selected"),
                // _buildToggleTextButtonView()
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 16),
                child: Text("Approvals", style: TextStyles.extraLargeTitleTextStyleBold)),
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
                child: Text("Approvals", style: TextStyles.extraLargeTitleTextStyleBold)),
            SizedBox(height: 8)
          ],
        ),
      );
    }
  }
}
