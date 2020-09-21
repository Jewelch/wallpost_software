import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SalesMyPortalFinancialDataList extends StatelessWidget {

  final String dataName;
  final int dataValue;

  SalesMyPortalFinancialDataList({this.dataName, this.dataValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top :3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(dataName),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: dataValue.toString(),
                style: TextStyle(
                  color: AppColors.defaultColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            TextSpan(
                text: ' QAR',
                style: TextStyle(color: Colors.black, fontSize: 10))
          ])),
        ],
      ),
    );
  }
}
