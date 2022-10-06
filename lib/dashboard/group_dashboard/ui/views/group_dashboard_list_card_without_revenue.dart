import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_wp_core/company_management/entities/company.dart';

class GroupDashboardListCardWithoutRevenue extends StatelessWidget {
  final Company company;
  final VoidCallback onPressed;

  GroupDashboardListCardWithoutRevenue({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _companyLogo(),
                Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  alignment: Alignment.center,
                  child: Text(
                    company.name,
                    style: TextStyles.largeTitleTextStyleBold,
                  ),
                ),
              ],
            ),
          ],
        ),
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
