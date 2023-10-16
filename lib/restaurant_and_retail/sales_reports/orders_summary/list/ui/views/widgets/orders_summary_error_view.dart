import 'package:flutter/material.dart';

import '../../../../../../../_common_widgets/text_styles/text_styles.dart';

class OrdersSummaryErrorView extends StatelessWidget {
  final String errorMessage;
  final void Function() onRetry;

  const OrdersSummaryErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
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
