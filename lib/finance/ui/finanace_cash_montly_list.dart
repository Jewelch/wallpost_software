import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceCashMonthlyList extends StatelessWidget {
  final FinanceDasBoardPresenter _presenter;
  FinanceCashMonthlyList(this._presenter);

  late final List<String> monthList;
  late final List<String> cashInList;
  late final List<String> cashOutList;

  @override
  Widget build(BuildContext context) {
    monthList = _presenter.getMonthList()!;
    cashInList = _presenter.getCashInList()!;
    cashOutList = _presenter.getCashOutList()!;

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
            Expanded(child: Text(monthList[index])),
            Expanded(child: _subTile('assets/icons/cash_in_icon.svg', cashInList[index], cashInList[index])),
            Expanded(child: _subTile('assets/icons/cash_out_icon.svg', cashOutList[index], cashOutList[index])),
          ],
        );
      },
    );
  }

  Widget _subTile(String icon, String label, String value) {
    return Row(
      children: [
        Container(height: 35, width: 35, child: SvgPicture.asset(icon, width: 40, height: 40)),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.textColorBlack),
            ),
          ],
        ),
      ],
    );
  }
}
