import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';
import 'header_card.dart';

class CollapsableHeaderCardController {
  bool _isExpanded = true;
  _CollapsableHeaderCardState? _state;

  CollapsableHeaderCardController({required bool isExpanded}) {
    _isExpanded = isExpanded;
  }

  void addState(_CollapsableHeaderCardState state) {
    _state = state;
  }

  void toggleSize() {
    assert(_isAttached, 'State not attached');
    _isExpanded = !_isExpanded;
    _state?.toggle();
  }

  bool isExpanded() {
    return _isExpanded;
  }

  void dispose() => _state = null;

  bool get _isAttached => _state != null;
}

class CollapsableHeaderCard extends StatefulWidget {
  final Widget expandedContent;
  final Widget collapsedContent;
  final double expandedHeight;
  final double collapsedHeight;
  final CollapsableHeaderCardController controller;
  final Color color;

  CollapsableHeaderCard({
    required this.expandedContent,
    required this.collapsedContent,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.controller,
    this.color = AppColors.defaultColorDark,
  });

  @override
  State<CollapsableHeaderCard> createState() => _CollapsableHeaderCardState(controller);
}

class _CollapsableHeaderCardState extends State<CollapsableHeaderCard> {
  CollapsableHeaderCardController _controller;

  _CollapsableHeaderCardState(this._controller) {
    _controller.addState(this);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeOut,
      width: double.infinity,
      height: _controller._isExpanded ? widget.expandedHeight : widget.collapsedHeight,
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.defaultColor.withOpacity(0.03),
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomPaint(
        painter: HeaderCardPainter(widget.color),
        child: _controller._isExpanded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: SingleChildScrollView(child: widget.expandedContent)),
                ],
              )
            : widget.collapsedContent,
      ),
    );
  }

  void toggle() {
    setState(() {});
  }
}
