import 'package:flutter/material.dart';

class FilterLoaderListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 40,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
