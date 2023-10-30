import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/finance/reports/stock_expiration/ui/presenter/stock_expiration_presenter.dart';

import 'stock_expiration_filter_container.dart';
import 'select_expire_or_not.dart';

class ExpiredOrNotFilter extends StatelessWidget {
  final StocksExpirationPresenter presenter;
  ExpiredOrNotFilter(this.presenter);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              SelectExpireOrNot.show(
                context,
                onSelectExpiration: presenter.onSelectFilter,
                initialValue: presenter.isExpired,
              );
            },
            child: StockExpirationFilterContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    presenter.isExpired ? "Only Expired" : "Expire In",
                    style: TextStyles.titleTextStyle.copyWith(
                      color: Colors.black.withOpacity(.6),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow_down_icon.svg',
                    color: Color.fromRGBO(43, 70, 93, 1),
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ),
          ),
          if (!presenter.isExpired) SizedBox(height: 12),
          if (!presenter.isExpired)
            StockExpirationFilterContainer(
              child: Row(
                children: [
                  Text(
                   presenter.days.toString() + " Days",
                    style: TextStyles.titleTextStyle.copyWith(
                      color: Colors.black.withOpacity(.6),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
