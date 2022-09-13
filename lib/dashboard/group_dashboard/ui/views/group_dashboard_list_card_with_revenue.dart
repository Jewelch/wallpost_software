import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_wp_core/company_management/entities/company.dart';
import '../models/financial_details.dart';
import '../presenters/group_dashboard_presenter.dart';

class GroupDashboardListCardWithRevenue extends StatelessWidget {
  final GroupDashboardPresenter presenter;
  final Company company;
  final VoidCallback onPressed;

  GroupDashboardListCardWithRevenue({required this.presenter, required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(company.name, style: TextStyles.largeTitleTextStyleBold)),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _companyLogo(),
                SizedBox(width: 6),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                    alignment: Alignment.centerLeft,
                    child: _tile(
                      presenter.getProfitLossDetails(company.financialSummary),
                      presenter.getOverdueReceivablesDetails(company.financialSummary),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                    alignment: Alignment.centerLeft,
                    child: _tile(
                      presenter.getAvailableFundsDetails(company.financialSummary),
                      presenter.getOverduePayablesDetails(company.financialSummary),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _companyLogo() {
    final borderRadius = BorderRadius.circular(20);
    return Container(
      width: 90,
      height: 90,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: Color.fromRGBO(240, 240, 240, 1.0), width: 2),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox.fromSize(
          size: Size.fromRadius(44),
          child: CachedNetworkImage(
            imageUrl: company.logoUrl,
            placeholder: (context, url) => Center(child: Icon(Icons.camera_alt)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _tile(FinancialDetails topFinancialDetails, FinancialDetails bottomFinancialDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        tileDetails(topFinancialDetails),
        SizedBox(height: 8),
        tileDetails(bottomFinancialDetails),
      ],
    );
  }

  Widget tileDetails(FinancialDetails financialDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          financialDetails.value,
          style: TextStyles.titleTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: financialDetails.textColor,
          ),
        ),
        Text(financialDetails.label, style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
      ],
    );
  }
}
