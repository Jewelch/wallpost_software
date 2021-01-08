import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CustomSegment extends StatefulWidget {
  final List<String> titles;
  final int selectedIndex;
  final Function(int) onChanged;

  CustomSegment({
    this.titles,
    this.selectedIndex = 0,
    this.onChanged,
  }) {
    assert(titles != null, 'Titles cannot be null');
    assert(titles.isNotEmpty, 'Titles cannot be empty');
    assert(selectedIndex < titles.length, 'Selected index cannot be greater than the number of titles');
  }

  @override
  _CustomSegmentState createState() => _CustomSegmentState(selectedIndex);
}

class _CustomSegmentState extends State<CustomSegment> with SingleTickerProviderStateMixin {
  int _selectedIndex;

  _CustomSegmentState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.defaultColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: _buildSegments(),
        ),
      ),
    );
  }

  List<Widget> _buildSegments() {
    List<Widget> segments = [];
    for (int i = 0; i < widget.titles.length; i++) {
      String title = widget.titles[i];
      segments.add(
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _selectedIndex == i ? AppColors.defaultColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() {
                  _selectedIndex = i;
                  widget.onChanged(_selectedIndex);
                }),
                child: Container(
                  child: Center(
                    child: Text(
                      title,
                      style: _selectedIndex == i
                          ? TextStyles.labelTextStyle.copyWith(color: Colors.white)
                          : TextStyles.labelTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return segments;
  }
}
