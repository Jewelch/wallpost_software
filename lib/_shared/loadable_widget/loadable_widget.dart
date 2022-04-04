import 'package:flutter/material.dart';
import 'package:wallpost/_shared/loadable_widget/widget_status.dart';

class LoadableWidget extends StatelessWidget {
  final WidgetStatus status;
  final Widget loadingWidget;
  final Widget child;
  final Widget errorWidget;

  LoadableWidget({
    required this.status,
    required this.loadingWidget,
    required this.child,
    required this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case WidgetStatus.loading:
        return loadingWidget;
      case WidgetStatus.ready:
        return child;
      case WidgetStatus.error:
        return errorWidget;
    }
  }
}
