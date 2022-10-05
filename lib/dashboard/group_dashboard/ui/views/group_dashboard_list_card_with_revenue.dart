import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_wp_core/company_management/entities/company.dart';
import '../../../finance_detail_views/ui/views/finance_detail_list_item.dart';

class GroupDashboardListCardWithRevenue extends StatelessWidget {
  final Company company;
  final VoidCallback onPressed;

  GroupDashboardListCardWithRevenue({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
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
                    SizedBox(width: 16),
                    if (company.financialSummary != null)
                      Expanded(child: FinanceDetailListItem(company.financialSummary!)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Divider(),
        ],
      ),
    );
  }

  Widget _companyLogo() {
    final borderRadius = BorderRadius.circular(20);
    return Container(
      width: 80,
      height: 80,
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
}
