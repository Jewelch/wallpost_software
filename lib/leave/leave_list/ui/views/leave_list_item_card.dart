import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../entities/leave_list_item.dart';
import '../presenters/leave_list_presenter.dart';

class LeaveListItemCard extends StatelessWidget {
  final LeaveListPresenter presenter;
  final LeaveListItem leaveListItem;

  LeaveListItemCard({
    required this.presenter,
    required this.leaveListItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () => presenter.selectItem(leaveListItem),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                presenter.getTitle(leaveListItem),
                style: TextStyles.titleTextStyleBold,
              ),
              SizedBox(height: 12),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: _labelAndValue(
                        "Start - ",
                        presenter.getStartDate(leaveListItem),
                      ),
                    ),
                    _labelAndValue(
                      "End - ",
                      presenter.getEndDate(leaveListItem),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _labelAndValue(
                    "",
                    presenter.getTotalLeaveDays(leaveListItem),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: _status()),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.textColorBlack,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status() {
    if (presenter.getStatus(leaveListItem) == null) return Container();

    return Text(
      presenter.getStatus(leaveListItem)!,
      textAlign: TextAlign.end,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.subTitleTextStyleBold.copyWith(
        color: presenter.getStatusColor(leaveListItem),
      ),
    );
  }

  Widget _labelAndValue(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.labelTextStyleBold.copyWith(color: AppColors.textColorGray),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
