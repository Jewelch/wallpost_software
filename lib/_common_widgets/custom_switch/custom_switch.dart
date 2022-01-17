import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool isOnInitially;
  final String offText;
  final String onText;
  final ValueChanged<bool> onChanged;

  CustomSwitch({
    this.isOnInitially = false,
    required this.offText,
    required this.onText,
    required this.onChanged,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState(isOnInitially);
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;
  bool isOn;

  _CustomSwitchState(this.isOn);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: isOn ? Alignment.centerRight : Alignment.centerLeft,
            end: isOn ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (isOn) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            isOn = !isOn;
            widget.onChanged(isOn);
          },
          child: Container(
            width: 100.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: _circleAnimation.value == Alignment.centerLeft ? AppColors.defaultColor : AppColors.defaultColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
              child: Container(
                alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  child: Center(
                    child: Text(_getSwitchText(), style: TextStyle(color: AppColors.defaultColor)),
                  ),
                  width: 50.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), shape: BoxShape.rectangle, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSwitchText() {
    return isOn ? widget.onText : widget.offText;
  }
}
