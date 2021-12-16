import 'package:flutter/material.dart';
// import 'package:progress_dialog/progress_dialog.dart';

class Loader {
  // ProgressDialog _progressDialog;

  Loader(BuildContext context) {
    // _progressDialog = ProgressDialog(
    //   context,
    //   type: ProgressDialogType.Normal,
    //   isDismissible: false,
    //   showLogs: false,
    // );
  }

  Future<void> show(String message) async {
    // if (_progressDialog.isShowing()) return;
    //
    // _progressDialog.style(
    //     message: message,
    //     padding: EdgeInsets.all(12),
    //     borderRadius: 10.0,
    //     backgroundColor: Colors.white,
    //     progressWidget: Container(
    //       padding: EdgeInsets.all(12),
    //       child: CircularProgressIndicator(),
    //     ),
    //     elevation: 2.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     messageTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.normal));
    // await _progressDialog.show();
  }

  Future<void> hide() async {
    // await _progressDialog.hide();
  }
}
