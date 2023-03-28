import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';

class SummarySalesErrorView extends StatelessWidget {
  final String errorMessage;
  final void Function() onRetry;

  const SummarySalesErrorView({
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
