import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';

class CompanyListCardWithRevenue extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithRevenue({required this.company, required this.onPressed});

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
                      company.financialSummary?.profitLoss ?? "",
                      "Profit & Loss",
                      Color(0xff25D06E),
                      company.financialSummary?.receivableOverdue ?? "",
                      "Receivables Overdue",
                      Color(0xffF62A20),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                    alignment: Alignment.centerLeft,
                    child: _tile(
                        company.financialSummary?.cashAvailability ?? "",
                        "Fund Availability",
                        Color(0xff25D06E),
                        company.financialSummary?.payableOverdue ?? "",
                        "Payables Overdue",
                        Color(0xffF62A20)),
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
      width: 100,
      height: 100,
      padding: EdgeInsets.all(6),
      // Border width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(color: Color.fromRGBO(240, 240, 240, 1.0), width: 2),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox.fromSize(
          size: Size.fromRadius(44), // Image radius
          child: CachedNetworkImage(
            imageUrl: company.logoUrl,
            placeholder: (context, url) => Center(child: Icon(Icons.camera_alt)),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _tile(
    String valueTop,
    String labelTop,
    Color colorTop,
    String valueBottom,
    String labelBottom,
    Color colorBottom,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        tileDetails(valueTop, labelTop, colorTop),
        SizedBox(height: 8),
        tileDetails(valueBottom, labelBottom, colorBottom)
      ],
    );
  }

  Widget tileDetails(
    String value,
    String label,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: TextStyles.titleTextStyle.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
      ],
    );
  }
}
