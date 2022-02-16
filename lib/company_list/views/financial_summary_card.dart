import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_cards/header_card.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

import '../../_common_widgets/buttons/circular_icon_button.dart';

class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummary _financialSummary;

  FinancialSummaryCard(this._financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        children: <Widget>[
          Row(children: [
            Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                    child: Text(
                      "Summary",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ))),
            Expanded(
                flex: 5,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[_financialSummaryFilterDropdown("YTD"), _financialSummaryFilterDropdown("2022")],
                ))
          ]),
          SizedBox(height: 8),
          Row(children: [
            Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "Profit & Loss",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                        fontSize: 16.0,
                      ),
                    ))),
            Expanded(
                flex: 6,
                child: Center(
                    child: Text(
                  _financialSummary.overallRevenue.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                      fontSize: 28.0,
                      overflow: TextOverflow.ellipsis),
                ))),
          ]),
          SizedBox(height: 6),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Fund Availability", Colors.green, _financialSummary.cashAvailability.toString())),
                SizedBox.fromSize(size: Size(10, 0)),
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Receivables Overdue", Colors.red, _financialSummary.receivableOverdue.toString())),
                SizedBox.fromSize(size: Size(10, 0)),
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Payables Overdue", Colors.red, _financialSummary.payableOverdue.toString())),
              ])),
        ],
      ),
    );
  }

  Widget _financialSummaryElement(String label, Color color, String value) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          children: [
            Divider(color: Colors.grey[400]),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 18.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey[400],
                fontSize: 11.0,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }

  Widget _financialSummaryFilterDropdown(String label) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Row(children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          CircularIconButton(
            iconName: 'assets/icons/down_arrow_icon.svg',
            iconSize: 12,
          )
        ]));
  }
}
