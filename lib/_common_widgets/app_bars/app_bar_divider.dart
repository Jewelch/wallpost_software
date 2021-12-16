// @dart=2.9

import 'package:flutter/material.dart';

class AppBarDivider extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(1);

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.black26);
  }
}
