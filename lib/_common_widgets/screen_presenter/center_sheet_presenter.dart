import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';

class CenterSheetController {
  _CenterSheetScreenState? _state;

  void _addState(_CenterSheetScreenState _state) {
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

class CenterSheetPresenter {
  static Future<dynamic> present({
    required BuildContext context,
    required Widget content,
    required CenterSheetController controller,
    bool shouldDismissOnTap = true,
  }) {
    return ScreenPresenter.present(
      _CenterSheetScreen(
        content: content,
        controller: controller,
        shouldDismissOnTap: shouldDismissOnTap,
      ),
      context,
      slideDirection: SlideDirection.none,
    );
  }
}

class _CenterSheetScreen extends StatefulWidget {
  final Widget content;
  final CenterSheetController? controller;
  final bool shouldDismissOnTap;

  const _CenterSheetScreen({required this.content, this.controller, required this.shouldDismissOnTap});

  @override
  _CenterSheetScreenState createState() => _CenterSheetScreenState();
}

class _CenterSheetScreenState extends State<_CenterSheetScreen> with SingleTickerProviderStateMixin {
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
    return WillPopScope(
      onWillPop: () {
        close();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
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
                      color: Colors.transparent,
                      child: Center(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 24),
                              child: widget.content,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> close({dynamic result}) {
    if (!_animationController.isDismissed)
      return _animationController.reverse().then((value) => Navigator.pop(context, result));
    return Future.value(null);
  }
}
