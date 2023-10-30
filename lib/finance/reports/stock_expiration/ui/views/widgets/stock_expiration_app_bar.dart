import '../../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../../_shared/constants/app_colors.dart';
import '../../../../../../_common_widgets/app_bars/company_name_app_bar.dart';
import '../../../../../../_common_widgets/search_bar/search_bar.dart';
import '../../presenter/stock_expiration_presenter.dart';
import 'package:flutter/material.dart' hide SearchBar;

class StocksExpirationAppBar extends StatelessWidget implements PreferredSizeWidget {
  StocksExpirationAppBar(
    this.presenter, {
    super.key,
  });

  final StocksExpirationPresenter presenter;

  @override
  Size get preferredSize => const Size(double.maxFinite, 172);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: AppColors.appBarShadowColor, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyNameAppBar(presenter.getCompanyName()),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(),
                    Text(
                      "Finance / Reports ",
                      style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Stock Expire",
                      style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              SearchBar(
                text: presenter.searchText,
                hint: 'Search',
                onSearchTextChanged: (searchText) => presenter.onSearch(searchText),
                autoFocus: false,
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
