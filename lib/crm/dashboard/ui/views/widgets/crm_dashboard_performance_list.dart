import 'package:flutter/material.dart';

import '../../presenters/crm_dashboard_presenter.dart';

class CrmDashboardPerformanceList extends StatelessWidget {
  final CrmDashboardPresenter _presenter;

  CrmDashboardPerformanceList(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _presenter.getNumberOfListItems(),
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _presenter.getTileForItemAtIndex(index),
              index < _presenter.getNumberOfListItems() - 1 ? Divider(height: 1) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
