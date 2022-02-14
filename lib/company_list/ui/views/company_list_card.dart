import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';

class CompanyListCard extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCard({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onPressed,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text(
                    company.name,
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
                            child: tile(company.financialSummary?.profitLoss ?? "NO FINANCES", "Profit & Loss", Colors.green,
                                company.financialSummary?.receivableOverdue  ?? "NO FINANCES", "Receivable Overdue", Colors.red),
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            alignment: Alignment.centerLeft,
                            child: tile(company.financialSummary?.cashAvailability ?? "NO FINANCES", "Fund Availability", Colors.green,
                                company.financialSummary?.payableOverdue ?? "NO FINANCES", "Payable Overdue", Colors.red),
                          )),
                    ],
                  )),
            ],
          )),
    );
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
          child:CachedNetworkImage(
            imageUrl: company.logoUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
