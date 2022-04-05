import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/header_card.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummary _financialSummary;

  FinancialSummaryCard(this._financialSummary);

  @override
  Widget build(BuildContext context) {
    return HeaderCard(
      content: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                child: Text(
                  "Summary",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _financialSummaryFilter("YTD"),
                  _financialSummaryFilter("2022")
                  // PopupMenuButton(
                  //   child: Container(
                  //       child: _financialSummaryFilterDropdown(_item)),
                  //   onSelected: (String value) => _onValueChanged(value),
                  //   color: Color(0xff4AF091),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  //   itemBuilder: (context) {
                  //     return _items.map((String item) {
                  //       return PopupMenuItem(
                  //         value: item,
                  //         child: Center(child: _financialSummaryFilter(item)),
                  //       );
                  //     }).toList();
                  //   },
                  // )
                ],
              ),
            )
          ]),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Profit & Loss",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                    fontSize: 16.0,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
              child: Center(
                  child: Text(
                _financialSummary.profitLoss.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4AF091),
                    fontSize: 28.0,
                    overflow: TextOverflow.ellipsis),
              )),
            ),
          ]),
          SizedBox(height: 6),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Fund Availability", Color(0xff4AF091), _financialSummary.cashAvailability.toString())),
                SizedBox.fromSize(size: Size(10, 0)),
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Receivables Overdue", Color(0xffFC6760), _financialSummary.receivableOverdue.toString())),
                SizedBox.fromSize(size: Size(10, 0)),
                Expanded(
                    flex: 3,
                    child: _financialSummaryElement(
                        "Payables Overdue", Color(0xffFC6760), _financialSummary.payableOverdue.toString())),
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
            SizedBox.fromSize(size: Size(0, 10)),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Color(0xffDFF0F7),
                fontSize: 11.0,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }

  Widget _financialSummaryFilter(String label) {
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
