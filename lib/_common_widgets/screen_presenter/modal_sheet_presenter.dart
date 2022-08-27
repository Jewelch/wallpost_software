import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';

class ModalSheetController {
  __ModalSheetScreenState? _state;

  void _addState(__ModalSheetScreenState _state) {
    this._state = _state;
  }

  bool get isAttached => _state != null;

  Future<void>? close({dynamic result}) {
    assert(isAttached, "State not attached.");
    return _state?.close(result: result);
  }

  void dispose() {
    _state = null;
  }
}

class ModalSheetPresenter {
  static Future<dynamic> present({
    required BuildContext context,
    required Widget content,
    required ModalSheetController controller,
    bool shouldDismissOnTap = true,
  }) {
    return ScreenPresenter.present(
      _ModalSheetScreen(
        content: content,
        controller: controller,
        shouldDismissOnTap: shouldDismissOnTap,
      ),
      context,
      slideDirection: SlideDirection.none,
    );
  }
}

class _ModalSheetScreen extends StatefulWidget {
  final Widget content;
  final ModalSheetController? controller;
  final bool shouldDismissOnTap;

  const _ModalSheetScreen({required this.content, this.controller, required this.shouldDismissOnTap});

  @override
  __ModalSheetScreenState createState() => __ModalSheetScreenState();
}

class __ModalSheetScreenState extends State<_ModalSheetScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> offset;
  late Animation<double> opacity;

  @override
  void initState() {
    if (widget.controller != null) widget.controller!._addState(this);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.reverseDuration = const Duration(milliseconds: 200);
    offset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_animationController);
    opacity =
        Tween<double>(begin: 0, end: 1.0).chain(CurveTween(curve: Curves.decelerate)).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          FadeTransition(
            opacity: opacity,
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          GestureDetector(
            onTap: () {
              if (widget.shouldDismissOnTap) close();
            },
            child: Container(color: Colors.transparent),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Flexible(
                child: SlideTransition(
                  position: offset,
                  child: Container(
                    constraints: BoxConstraints.loose(const Size(double.infinity, 700)),
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CurveBottomToTop(),
                        Flexible(child: Container(color: Colors.white, child: widget.content)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> close({dynamic result}) {
    if (!_animationController.isDismissed)
      return _animationController.reverse().then((value) => Navigator.pop(context, result));
    return Future.value(null);
  }
}
