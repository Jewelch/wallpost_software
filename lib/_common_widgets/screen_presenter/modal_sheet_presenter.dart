import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';

import '../buttons/circular_icon_button.dart';
import '../text_styles/text_styles.dart';

class ModalSheetController {
  __ModalSheetScreenState? _state;

  void _addState(__ModalSheetScreenState _state) {
    this._state = _state;
  }

  bool get isAttached => _state != null;

  void close() {
    assert(isAttached, "State not attached.");
    _state?.close();
  }

  void dispose() {
    _state = null;
  }
}

class ModalSheetPresenter {
  static Future<dynamic> present<T extends Object>({
    required BuildContext context,
    required String title,
    required Widget content,
    required ModalSheetController controller,
  }) {
    return ScreenPresenter.present(
      _ModalSheetScreen(
        content: content,
        title: title,
        controller: controller,
      ),
      context,
      slideDirection: SlideDirection.fromBottom,
    );
  }
}

class _ModalSheetScreen extends StatefulWidget {
  final Widget content;
  final String title;
  final ModalSheetController controller;

  _ModalSheetScreen({
    required this.content,
    required this.title,
    required this.controller,
  });

  @override
  __ModalSheetScreenState createState() => __ModalSheetScreenState(modalSheetController: controller);
}

class __ModalSheetScreenState extends State<_ModalSheetScreen> with SingleTickerProviderStateMixin {
  ModalSheetController? _modalSheetController;
  late AnimationController _animationController;
  late Animation<Offset> offset;

  __ModalSheetScreenState({ModalSheetController? modalSheetController}) {
    if (modalSheetController != null) {
      this._modalSheetController = modalSheetController;
      _modalSheetController!._addState(this);
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController.reverseDuration = Duration(milliseconds: 200);
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_animationController);
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
          Container(color: Colors.black.withOpacity(0.7)),
          GestureDetector(
            onTap: () => close(),
            child: Container(color: Colors.transparent),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Flexible(
                child: SlideTransition(
                  position: offset,
                  child: Container(
                    constraints: BoxConstraints.loose(Size(double.infinity, 600)),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyles.largeTitleTextStyle,
                                ),
                              ),
                              CircularIconButton(
                                iconName: 'assets/icons/close_icon.svg',
                                iconSize: 14,
                                onPressed: () => close(),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                        Divider(height: 1),
                        Flexible(child: widget.content),
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

  close() {
    _animationController.reverse().then((value) => Navigator.pop(context));
  }
}
