import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';

class RadioGroup extends StatelessWidget {
  final List<String> items;
  final Function(int) onDidSelectRadioItemAtIndex;
  final int? selectedIndex;

  const RadioGroup({
    required this.items,
    required this.onDidSelectRadioItemAtIndex,
    this.selectedIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: getRadioButtons());
  }

  List<_RadioContainer> getRadioButtons() {
    List<_RadioContainer> radioButtons = [];
    for (int i = 0; i < items.length; i++) {
      radioButtons.add(
        _RadioContainer(
          title: items[i],
          isSelected: selectedIndex == i,
          onTap: () => onDidSelectRadioItemAtIndex.call(i),
        ),
      );
    }
    return radioButtons;
  }
}

class _RadioContainer extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final bool isSelected;

  const _RadioContainer({
    required this.onTap,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, right: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.textFieldBackgroundColor), borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyles.labelTextStyle
                  .copyWith(color: isSelected ? AppColors.defaultColor : AppColors.textColorDarkGray, fontSize: 13.0),
            ),
            SizedBox(width: 16),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
              color: AppColors.defaultColor,
            ),
          ],
        ),
      ),
    );
  }
}
