import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/company_name_app_bar.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenters/receivables_and_ageing_presenter.dart';

class ReceivablesAppBar extends StatelessWidget implements PreferredSizeWidget {
  ReceivablesAppBar(
    this.presenter, {
    super.key,
  });

  static final appbarNotifier = ItemNotifier<bool>(defaultValue: false);
  final ReceivablesPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 112);

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<bool>(
      notifier: appbarNotifier,
      builder: (context, displayBackground) => AppBar(
        elevation: 0,
        backgroundColor: AppColors.screenBackgroundColor,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        bottom: _AppBarWidget(presenter, displayBackground),
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  _AppBarWidget(this.presenter, this.displayBackground);

  final bool displayBackground;
  final ReceivablesPresenter presenter;

  @override
  Size get preferredSize => const Size(1200, 0);

  @override
  Widget build(BuildContext context) => ProfitsLossesAppBar(presenter, displayBackground);
}

class ProfitsLossesAppBar extends StatelessWidget {
  final ReceivablesPresenter presenter;
  final bool displayBackground;

  const ProfitsLossesAppBar(
    this.presenter,
    this.displayBackground, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 400,
          height: 50,
          color: displayBackground ? AppColors.screenBackgroundColor : AppColors.screenBackgroundColor2,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.screenBackgroundColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: AppColors.appBarShadowColor, offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyNameAppBar(presenter.getSelectedCompanyName()),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Finance/Reports",
                      style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Receivables & Ageing",
                      style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
