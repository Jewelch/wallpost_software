import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/dashboard_management/entities/Dashboard.dart';

class CompanyListCard extends StatelessWidget {
  final Company company;
  final VoidCallback onPressed;

  CompanyListCard({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Text(
                  company.companyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 21.0,
                  ),
                )),
            SizedBox(height: 2),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 2, child: avatar()),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                          alignment: Alignment.centerLeft,
                          child: tile(company.financialSummary.profitLoss.toString(), "Profit & Loss", Colors.green,
                              company.financialSummary.receivableOverdue.toString(), "Receivable Overdue", Colors.red),
                        )),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                          alignment: Alignment.centerLeft,
                          child: tile(company.financialSummary.cashAvailability.toString(), "Fund Availability", Colors.green,
                              company.financialSummary.payableOverdue.toString(), "Payable Overdue", Colors.red),
                        )),
                  ],
                )),
          ],
        ));
  }

  Widget avatar() {
    final borderRadius = BorderRadius.circular(20);
    return Container(
      padding: EdgeInsets.all(2), // Border width
      decoration: BoxDecoration(
          color: AppColors.primaryContrastColor, borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox.fromSize(
          size: Size.fromRadius(44), // Image radius
          child: FadeInImage.assetNetwork(
              placeholder: 'assets/logo/placeholder.jpg',
              image:company.avatar,
              fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget tile(String valueTop, String labelTop, Color colorTop,
      String valueBottom, String labelBottom, Color colorBottom) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              tileDetails(valueTop, labelTop, colorTop),
              SizedBox(height: 10),
              tileDetails(valueBottom, labelBottom, colorBottom)
            ]));
  }

  Widget tileDetails(String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color,
              overflow: TextOverflow.ellipsis,
              fontSize: 17.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            label,
            style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        ],
      ),
    );
  }
}
