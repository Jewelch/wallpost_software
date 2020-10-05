import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SalesFinancialsDataView extends StatelessWidget {
  final String financeDataName;
  final String financeDataValue;

  SalesFinancialsDataView({this.financeDataName, this.financeDataValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(financeDataName),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: financeDataValue,
                style: TextStyle(
                  color: AppColors.defaultColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            TextSpan(
                text: ' QAR',
                style: TextStyle(color: Colors.black, fontSize: 12))
          ])),
        ],
      ),
    );
  }
}
