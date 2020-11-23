import 'package:flutter/material.dart';

class LoaderListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
