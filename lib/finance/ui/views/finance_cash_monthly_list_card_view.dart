import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';

class FinanceCashMonthlyListCardView extends StatelessWidget {
  final FinanceDashboardPresenter _presenter;

  FinanceCashMonthlyListCardView(this._presenter);

  @override
  Widget build(BuildContext context) {
    return dataView();
  }

  Widget dataView() {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _presenter.getMonthList()[index].capitalize(),
              style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.textColorGray),
            ),
            SizedBox(width: 28),
            Expanded(child: _subTile('assets/icons/cash_in_icon.svg', _presenter.getCashInList()[index])),
            Expanded(child: _subTile('assets/icons/cash_out_icon.svg', _presenter.getCashOutList()[index])),
          ],
        );
      },
    );
  }

  Widget _subTile(String icon, String value) {
    return Row(
      children: [
        Container(height: 28, width: 28, child: SvgPicture.asset(icon)),
        SizedBox(width: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: TextStyles.largeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
