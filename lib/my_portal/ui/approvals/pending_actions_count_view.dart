import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/my_portal/entities/pending_actions_count.dart';
import 'package:wallpost/my_portal/services/pending_actions_count_provider.dart';

class PendingActionsCountView extends StatefulWidget {
  @override
  _PendingActionsCountViewState createState() =>
      _PendingActionsCountViewState();
}

class _PendingActionsCountViewState extends State<PendingActionsCountView> {
  PendingActionsCount _pendingActionsCount;
  bool showError = false;

  @override
  void initState() {
    _getPendingActionCount();
    super.initState();
  }

  void _getPendingActionCount() async {
    setState(() {
      _pendingActionsCount = null;
      showError = false;
    });

    try {
      var counts = await PendingActionsCountProvider().getCount();
      setState(() {
        _pendingActionsCount = counts;
      });
    } on APIException catch (_) {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingActionsCount != null) {
      return _buildPendingActionCount();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
  }

  Widget _buildPendingActionCount() {
    return Column(children: [
      _buildlistPendingActions(
          approvalName: 'Task',
          approvalCount: _pendingActionsCount.taskApprovalsCount),
      Divider(),
      _buildlistPendingActions(
          approvalName: 'Leaves',
          approvalCount: _pendingActionsCount.leaveApprovalsCount),
      Divider(),
      _buildlistPendingActions(
          approvalName: 'Handover',
          approvalCount: _pendingActionsCount.handoverApprovalsCount),
    ]);
  }

  Widget _buildlistPendingActions({String approvalName, int approvalCount}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(approvalName),
          approvalCount > 0
              ? Container(
                  width: 32,
                  height: 20,
                  child: Center(
                      child: Text(
                    '$approvalCount',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.defaultColor),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to performance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                setState(() {});
                _getPendingActionCount();
              },
            ),
          ],
        ),
      ),
    );
  }
}
