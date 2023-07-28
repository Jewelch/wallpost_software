import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';

class RestaurantDashboardErrorView extends StatelessWidget {
  final String errorMessage;
  final void Function() onRetry;

  const RestaurantDashboardErrorView({Key? key, required this.errorMessage, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: TextButton(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyles.titleTextStyle,
          ),
          onPressed: onRetry,
        ),
      ),
    );
  }
}
