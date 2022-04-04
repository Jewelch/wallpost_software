import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';

class CompanyListCardWithoutRev extends StatelessWidget {
  final CompanyListItem company;
  final VoidCallback onPressed;

  CompanyListCardWithoutRev({required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 2),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      avatar(),
                       Container(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            alignment: Alignment.center,
                           child :Text(
                                 company.name,
                                 style: const TextStyle(
                                   fontWeight: FontWeight.w700,
                                   color: Colors.black,
                                   fontSize: 21.0,
                                 ),
                               ),
                          ),
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
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(color: AppColors.greyColor)),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox.fromSize(
          size: Size.fromRadius(44), // Image radius
          child: CachedNetworkImage(
            imageUrl: company.logoUrl,
            placeholder: (context, url) =>
                Center(child: Icon(Icons.camera_alt)),
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
              fontSize: 18.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            label,
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
        ],
      ),
    );
  }
}
