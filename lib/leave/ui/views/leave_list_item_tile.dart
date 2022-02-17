import 'package:flutter/material.dart';

import '../../entities/leave_list_item.dart';

class LeaveListItemTile extends StatelessWidget {
  final LeaveListItem _leaveListItem;

  LeaveListItemTile(this._leaveListItem);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          color: Colors.grey,
          child: Text(_leaveListItem.leaveId),
        ),
        Container(height: 2),
      ],
    );
  }
}
